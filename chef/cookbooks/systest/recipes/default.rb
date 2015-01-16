#
# Cookbook Name:: systest
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_ssl"
include_recipe "php"
include_recipe "php::module_mysql"

user "blogger" do
  supports :manage_home => true
  comment "blogger User"
  gid "users"
  home "/home/blogger"
  shell "/bin/bash"
  password "$1$mJ6aTqJG$KJJ1r4dMdZ9M7KRgqiP.Y/"
end

sudo 'blogger' do
  user      "blogger"
  commands  ['/etc/init.d/hostname']
end

mysql_service 'default' do
  version '5.6'
  run_user 'mysql'
  run_group 'mysql'
  bind_address '0.0.0.0'
  port '3306'  
  data_dir '/var/lib/mysql'
  initial_root_password node['mysql']['server_root_password'] 
  action [:start]
end

mysql_database node['wordpress']['database'] do
  connection ({:host => '127.0.0.1', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['wordpress']['db_username'] do
  connection ({:host => '127.0.0.1', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['wordpress']['db_password']
  database_name node['wordpress']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

apache_module "mpm_event" do
  enable false
end

apache_module "mpm_prefork" do
  enable true
end

wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"

remote_file wordpress_latest do
  source "http://wordpress.org/latest.tar.gz"
  mode "0644"
end

directory node["wordpress"]["path"] do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd node['wordpress']['path']
  command "tar --strip-components 1 -xzf " + wordpress_latest
  creates node['wordpress']['path'] + "/wp-settings.php"
end

wp_secrets = Chef::Config[:file_cache_path] + '/wp-secrets.php'

if File.exist?(wp_secrets)
  salt_data = File.read(wp_secrets)
else
  require 'open-uri'
  salt_data = open('https://api.wordpress.org/secret-key/1.1/salt/').read
  open(wp_secrets, 'wb') do |file|
    file << salt_data
  end
end

template node['wordpress']['path'] + '/wp-config.php' do
  source 'wp-config.php.erb'
  mode 0755
  owner 'root'
  group 'root' 
  variables(
    :database        => node['wordpress']['database'],
    :user            => node['wordpress']['db_username'],
    :password        => node['wordpress']['db_password'],
    :wp_secrets      => salt_data)
end

web_app 'systest' do
  template 'wordpress.conf.erb'
  docroot node['wordpress']['path']
  server_name node['systest']['server_name']
end

directory '/etc/ssl/localcerts' do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

cookbook_file 'apache.pem' do
  path '/etc/ssl/localcerts/apache.pem'
  action :create_if_missing
end

cookbook_file 'apache.key' do
  path '/etc/ssl/localcerts/apache.key'
  action :create_if_missing
end

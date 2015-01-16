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

mysql_database node['systest']['database'] do
  connection ({:host => '127.0.0.1', :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end

mysql_database_user node['systest']['db_username'] do
  connection ({:host => '127.0.0.1', :username => 'root', :password => node['mysql']['server_root_password']})
  password node['wordpress_user']['db_password']
  database_name node['systest']['database']
  privileges [:select,:update,:insert,:create,:delete]
  action :grant
end

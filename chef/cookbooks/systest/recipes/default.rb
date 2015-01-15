#
# Cookbook Name:: systest
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

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

#
# Cookbook Name:: deploy_permissions
# Recipe:: nginx
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

acl "/usr/sbin/nxensite" do
  group node[:deploy_permissions][:group_name]
  modify "r-x"
end

acl "/usr/sbin/nxdissite" do
  group node[:deploy_permissions][:group_name]
  modify "r-x"
end

acl "/etc/nginx/sites-available" do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

acl "/etc/nginx/sites-enabled" do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

sudo "deploy_permissions_nginx" do
  group node[:deploy_permissions][:group_name]

  commands [
    "/etc/init.d/nginx reload",
    "/etc/init.d/nginx configtest",
  ]

  host "ALL"
  nopasswd true
end

#
# Cookbook Name:: deploy_permissions
# Recipe:: apache
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "deploy_permissions"
include_recipe "sudo"

acl "/usr/sbin/a2ensite" do
  group node[:deploy_permissions][:group_name]
  modify "r-x"
end

acl "/usr/sbin/a2dissite" do
  group node[:deploy_permissions][:group_name]
  modify "r-x"
end

acl "/etc/httpd/sites-available" do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

acl "/etc/httpd/sites-enabled" do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

sudo "deploy_permissions_apache" do
  group node[:deploy_permissions][:group_name]

  commands [
    "/sbin/service httpd reload",
    "/etc/init.d/httpd reload",
    "/sbin/service httpd configtest",
    "/etc/init.d/httpd configtest",
  ]

  host "ALL"
  nopasswd true
end

#
# Cookbook Name:: deploy_permissions
# Recipe:: supervisor
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "deploy_permissions"

acl node[:supervisor][:dir] do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

sudo "deploy_permissions_supervisor" do
  group node[:deploy_permissions][:group_name]

  commands [
    "/usr/bin/supervisorctl",
    "/usr/local/bin/supervisorctl_rolling_restart",
  ]

  host "ALL"
  nopasswd true
end

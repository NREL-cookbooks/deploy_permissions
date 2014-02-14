#
# Cookbook Name:: deploy_permissions
# Recipe:: torquebox
#
# Copyright 2014, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

acl "#{node[:torquebox][:conf_dir]}/deployments" do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

sudo "deploy_permissions_torquebox" do
  group node[:deploy_permissions][:group_name]

  commands [
    "/bin/rm -f #{node[:torquebox][:dir]}/home/jboss/standalone/deployments/*-knob.yml*",
  ]

  host "ALL"
  nopasswd true
end

# Cleanup old file from sudo cookbook.
sudo "torquebox_deployment" do
  action :remove
end

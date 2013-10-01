#
# Cookbook Name:: deploy_permissions
# Recipe:: supervisor
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

acl node[:supervisor][:dir] do
  group node[:deploy_permissions][:group_name]
  modify "rwx"
end

#
# Cookbook Name:: deploy_permissions
# Recipe:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

group node[:deploy_permissions][:group_name] do
  action :create
end

group node[:deploy_permissions][:group_name] do
  action :modify
  members node[:deploy_permissions][:group_members]
end

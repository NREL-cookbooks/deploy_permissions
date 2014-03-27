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

node[:deploy_permissions][:writable_dirs].each do |dir|
  directory(dir) do
    user "root"
    group node[:deploy_permissions][:group_name]

    # Add the setgid bit so all child files/directories automatically become
    # owned by this same deploy group.
    mode "2775"
  end

  # Set a default ACL on the directory allowing the deploy group full
  # permissions. This default ACL will automatically be applied to all children
  # items.
  #
  # This combined with the setgid allow should ensure that the group maintains
  # full access to everything in this directory. Based on:
  # http://brunogirin.blogspot.ca/2010/03/shared-folders-in-ubuntu-with-setgid.html
  acl(dir) do
    default true
    recursive true
    group node[:deploy_permissions][:group_name]
    modify "rwx"
  end
end

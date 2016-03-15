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

user node[:deploy_permissions][:user] do
  gid node[:deploy_permissions][:group_name]
  supports :manage_home => true
  shell "/bin/bash"
end

group node[:deploy_permissions][:group_name] do
  action :modify
  members node[:deploy_permissions][:group_members]
end

sudo "deploy_permissions" do
  template "sudo.erb"
  variables({
    :user => node[:deploy_permissions][:user],
    :group => node[:deploy_permissions][:group_name],
    :runas => [
      node[:deploy_permissions][:user],
      node[:deploy_permissions][:runas],
    ].flatten.compact.uniq,
  })
end

node[:deploy_permissions][:writable_dirs].each do |dir|
  directory(dir) do
    recursive true
    user node[:deploy_permissions][:user]
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

ssh_dir = "/home/#{node[:deploy_permissions][:user]}/.ssh"
authorized_keys_file = "#{ssh_dir}/authorized_keys"

directory ssh_dir do
  owner node[:deploy_permissions][:user]
  group node[:deploy_permissions][:group_name]
  mode "0700"
end

file authorized_keys_file do
  owner node[:deploy_permissions][:user]
  group node[:deploy_permissions][:group_name]
  mode "0600"
end

node[:deploy_permissions][:ssh_authorized_keys].each do |key|
  ruby_block "deployer_authorized_keys - #{key[0..20]}..." do
    block do
      File.open(authorized_keys_file, "a") do |file|
        file.puts(key)
      end
    end
    not_if { File.exists?(authorized_keys_file) && File.read(authorized_keys_file).include?(key) }
  end
end

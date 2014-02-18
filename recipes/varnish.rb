#
# Cookbook Name:: deploy_permissions
# Recipe:: varnish
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "deploy_permissions"
include_recipe "sudo"

sudo "deploy_permissions_varnish" do
  group node[:deploy_permissions][:group_name]

  commands [
    "/usr/local/bin/varnish_ban",
  ]

  host "ALL"
  nopasswd true
end

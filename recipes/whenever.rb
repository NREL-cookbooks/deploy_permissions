#
# Cookbook Name:: deploy_permissions
# Recipe:: whenever
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

sudo "deploy_permissions_whenever" do
  group node[:deploy_permissions][:group_name]

  commands [
    "/opt/rbenv/shims/bundle exec whenever --user apache *",
  ]

  host "ALL"
  nopasswd true
end

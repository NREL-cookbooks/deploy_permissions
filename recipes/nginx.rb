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

# Logrotate for logs that need to be owned by the deploy user (for deployment
# purposes), but should reload nginx when rotated (so, for example, Passenger
# Rails log files).
logrotate_app "nginx_deploy_permissions" do
  path node[:deploy_permissions][:nginx][:logrotate_paths]
  frequency "daily"
  rotate node[:nginx][:logrotate][:rotate]
  create "664 #{node[:deploy_permissions][:user]} #{node[:nginx][:group]}"
  options %w(missingok compress delaycompress notifempty)
  sharedscripts true

  # Ideally we send nginx the "reopen" signal so a full reload isn't
  # necessary. But this doesn't properly rotate Pasenger's Rails log files,
  # so we'll do a "reload" instead.
  postrotate "#{node[:nginx][:binary]} -s reload"
end

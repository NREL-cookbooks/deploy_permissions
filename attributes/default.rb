#
# Cookbook Name:: deploy_permissions
# Attributes:: default
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:deploy_permissions][:user] = "deploy"
default[:deploy_permissions][:group_name] = "deploy"
default[:deploy_permissions][:group_members] = []
default[:deploy_permissions][:runas] = []
default[:deploy_permissions][:writable_dirs] = []

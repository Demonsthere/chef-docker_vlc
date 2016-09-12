#
# Cookbook Name:: docker_vlc
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
cookbook_file '/etc/apt/sources.list' do
  source 'sources.list'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'do a system update, since we changed sources' do
  command 'apt-get update'
  action :run
end

apt_package 'devscripts' do
  action :install
  options '--no-install-recommends'
end

directory node[:docker_vlc][:workspace] do
  owner 'root'
  group 'root'
  action :create
end

execute 'get vlc build dependencies' do
  command "apt-get build-dep -y vlc"
  action :run
  cwd node[:docker_vlc][:workspace]
end

execute 'get vlc sources' do
  command "apt-get source -y vlc=#{node[:docker_vlc][:vlc_version]}"
  action :run
  cwd node[:docker_vlc][:workspace]
end

cookbook_file "#{node[:docker_vlc][:compilation_dir]}/debian/rules" do
  source 'rules'
  owner 'root'
  group 'root'
  mode '0755'
end

cookbook_file "#{node[:docker_vlc][:compilation_dir]}/debian/vlc-nox.install.in" do
  source 'vlc-nox.install.in'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'Compile the package' do
  command 'debuild -i -us -uc -b'
  cwd node[:docker_vlc][:compilation_dir]
  action :run
end

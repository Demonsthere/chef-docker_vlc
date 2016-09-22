require 'mixlib/shellout'
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

execute 'do an apt cleanup' do
  command 'apt-get clean && apt-get autoclean'
  action :run
end

execute 'do a system update' do
  command 'apt-get update --fix-missing'
  action :run
end

execute 'update system keys' do
  command 'apt-key update'
  action :run
end

node[:docker_vlc][:packages].each do |pkg|
  apt_package pkg do
    action :install
    options '--no-install-recommends --allow-unauthenticated'
  end
end

directory node[:docker_vlc][:workspace] do
  owner 'root'
  group 'root'
  action :create
end

execute 'get vlc build dependencies' do
  command "apt-get build-dep -y --force-yes vlc"
  action :run
  cwd node[:docker_vlc][:workspace]
end

execute 'get vlc sources' do
  command "apt-get source -y --force-yes --allow-unauthenticated vlc=#{node[:docker_vlc][:vlc_version]}"
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

ruby_block 'Compile the package' do
  block do
    # command = "/bin/bash -c 'cd #{node[:docker_vlc][:compilation_dir]} && debuild -i -us -uc -b'"
    # shell_out!(command, timeout: 100000)
    cmd = Mixlib::ShellOut.new("debuild", "-i -us -uc -b", :cwd => node[:docker_vlc][:compilation_dir], :timeout => 100000)
    cmd.run_command # etc.
  end
end

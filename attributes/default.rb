default[:docker_vlc][:workspace] = '/workspace'
default[:docker_vlc][:vlc_version] = '2.2.1'
default[:docker_vlc][:compilation_dir] = "#{node[:docker_vlc][:workspace]}/vlc-#{node[:docker_vlc][:vlc_version]}"

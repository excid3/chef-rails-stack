package 'git-core'

user node[:user][:name] do
  password node[:user][:password]
  gid "admin"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/bash"
end

include_recipe "rvm::user"

include_recipe "nginx::source"
include_recipe "postgresql::server"
include_recipe "postgresql::client"

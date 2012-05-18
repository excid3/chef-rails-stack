package 'git-core'

user node[:user][:name] do
  password node[:user][:password]
  gid "admin"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/bash"
end

%w(
   ruby_build
   rbenv::system
   nginx::source
   nginx::rails_unicorn
   postgresql::server
   postgresql::client
   logrotate
   sudo).
   each {|recipe| include_recipe recipe}
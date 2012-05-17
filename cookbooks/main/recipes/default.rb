# PRE CHEF
# curl -Lo- https://raw.github.com/gist/2709199/1119ddedac87aac2870b3f440100563ba21727a2/gistfile1.sh | bash

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

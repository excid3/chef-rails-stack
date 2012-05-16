# PRE CHEF
# curl -Lo- https://raw.github.com/gist/2709199/c47571f2b33a8f49a9bc2714cc6ec9420c976ef5/gistfile1.sh | bash

package 'git-core'
package 'bash'

include_recipe "nginx::source"
include_recipe "postgresql::server"
include_recipe "postgresql::client"

user node[:user][:name] do
  password node[:user][:password]
  gid "admin"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/bash"
end
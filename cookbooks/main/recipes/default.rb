# PRE CHEF
# curl -Lo- https://raw.github.com/gist/2709199/7f39ab152eef15d90800e758b9fa874a9ec85304/gistfile1.sh | bash

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
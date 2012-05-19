package 'git-core'

group "deployer" do
  gid 4000
end

%w(
   users
   ruby_build
   rbenv::system
   nginx::source
   nginx::rails_unicorn
   postgresql::server
   postgresql::client
   logrotate
   sudo).
   each {|recipe| include_recipe recipe}
package 'git-core'

node[:groups].each do |g|
  group g[:name] do
    gid g[:gid]
  end
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
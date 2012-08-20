package 'git-core'

node[:groups].each do |g|
  group g[:name] do
    gid g[:gid]
  end
end

%w(
   ruby-shadow
   users
   ruby_build
   rbenv::system
   nginx::source
   nginx::rails_unicorn
   postgresql::server
   postgresql::client
   logrotate
   sudo
   revealcloud).
   each {|recipe| include_recipe recipe}
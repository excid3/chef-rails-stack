#
# Cookbook Name:: users
# Recipe:: default
#

node[:users].each do |user|
  
  group user[:username] do
    gid user[:gid]
  end

  home_dir = "/home/#{user[:username]}"
  
  directory home_dir do
    owner user[:uid]
    group user[:gid]
    mode 0755
  end

  user user[:username] do
    password user[:password].crypt(user[:username]) if user[:password]
    uid user[:uid]
    gid user[:gid]
    home home_dir
    shell user[:shell] || "/bin/bash"
    action :create
  end

  directory "#{home_dir}/.ssh" do
    owner user[:uid]
    group user[:gid]
    mode 0700
  end
  
  if user[:authorized_keys]
    template "#{home_dir}/.ssh/authorized_keys" do
      owner user[:uid]
      group user[:gid]
      mode 0600
      source "authorized_keys.erb"
      variables :user => user
    end 
  end

  if user[:known_hosts]
    template "#{home_dir}/.ssh/known_hosts" do
      owner user[:uid]
      group user[:gid]
      mode 0600
      source "known_hosts.erb"
      variables :user => user
    end 
  end
  
end

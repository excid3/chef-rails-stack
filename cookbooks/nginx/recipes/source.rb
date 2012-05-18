#
# Cookbook Name:: nginx
# Recipe:: source
#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "build-essential"

unless platform?("centos","redhat","fedora")
  include_recipe "runit"
end

packages = value_for_platform(
    ["centos","redhat","fedora"] => {'default' => ['pcre-devel', 'openssl-devel']},
    "default" => ['libpcre3', 'libpcre3-dev', 'libssl-dev']
  )

packages.each do |devpkg|
  package devpkg
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

directory node[:nginx][:dir] do
  owner "root"
  group "root"
  mode "0755"
end

%w{ sites-available sites-enabled conf.d }.each do |dir|
  directory "#{node[:nginx][:dir]}/#{dir}" do
    owner "root"
    group "root"
    mode "0755"
  end
end

%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode "0755"
    owner "root"
    group "root"
  end
end

nginx_version = node[:nginx][:version]

node.set[:nginx][:daemon_disable] = true

node[:nginx][:modules].each do |modul|
  include_recipe "nginx::#{modul}"
end

# Rebuild configure_flags attribute: The key here is throwing out the --prefix flag
# which may exist from a previous run and may be incorrect if a previous version of
# NGINX was installed.
node.set[:nginx][:configure_flags] = node[:nginx][:configure_flags].reject { |flag| flag =~ /--prefix=.+/ } | 
  [ "--prefix=#{node[:nginx][:install_path]}", "--conf-path=#{node[:nginx][:dir]}/nginx.conf" ]

configure_flags = node[:nginx][:configure_flags].join(" ")

remote_file "#{Chef::Config[:file_cache_path]}/nginx-#{nginx_version}.tar.gz" do
  source "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
  action :create_if_missing
end

unless platform?("centos","redhat","fedora")
  runit_service "nginx"

  service "nginx" do
    action :nothing
  end
else
  #install init db script
  template "/etc/init.d/nginx" do
    source "nginx.init.erb"
    owner "root"
    group "root"
    mode "0755"
  end

  #install sysconfig file (not really needed but standard)
  template "/etc/sysconfig/nginx" do
    source "nginx.sysconfig.erb"
    owner "root"
    group "root"
    mode "0644"
  end

  #register service
  service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :nothing]
  end
end

file node[:nginx][:src_binary] do
  action :nothing
end

# The compiled_with_flags file contains the list of flags which NGINX
# was compiled with last. If this file changes, it means that the
# desired flags have changed so the nginx binary is destroyed to force
# the compile_nginx_source resource to run.
template "#{Chef::Config[:file_cache_path]}/nginx-#{nginx_version}-compiled_with_flags" do
  source "compiled_with_flags.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :stop, "service[nginx]", :immediately
  notifies :delete, resources(:file => node[:nginx][:src_binary]), :immediately
end

bash "compile_nginx_source" do
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
    tar zxf nginx-#{nginx_version}.tar.gz
    cd nginx-#{nginx_version} && ./configure #{configure_flags}
    make && make install
  EOH
  creates node[:nginx][:src_binary]
  notifies :restart, "service[nginx]"
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx"), :immediately
end

cookbook_file "#{node[:nginx][:dir]}/mime.types" do
  source "mime.types"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx"), :immediately
end

if platform?("ubuntu","debian")
  template "/etc/logrotate.d/nginx" do
    path "/etc/logrotate.d/nginx"
    source "nginx_log_rotate.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end

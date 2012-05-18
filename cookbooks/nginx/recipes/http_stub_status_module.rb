#
# Cookbook Name:: nginx
# Recipe:: http_stub_status_module
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2011, Vial Studios, Inc.
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

node.set[:nginx][:configure_flags] = 
  node[:nginx][:configure_flags] | ['--with-http_stub_status_module']
  
node.default[:nginx][:remote_ip_var]           = "remote_addr"
node.default[:nginx][:status][:authorized_ips] = ["127.0.0.1/32"]

service "nginx" do
  action :nothing
end

template "nginx_status" do
  path "#{node[:nginx][:dir]}/sites-available/nginx_status"
  source "nginx_status.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

template "authorized_ip" do
  path "#{node[:nginx][:dir]}/authorized_ip"
  source "authorized_ip.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "nginx")
end

nginx_site "nginx_status"

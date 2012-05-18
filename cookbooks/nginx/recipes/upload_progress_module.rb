#
# Cookbook Name:: nginx
# Recipe:: upload_progress_module
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

upload_progress_version = node.default[:nginx][:upload_progress_version] = "0.8.2"
remote_file "#{Chef::Config[:file_cache_path]}/nginx-upload-progress-module-v#{upload_progress_version}.tar.gz" do
  source "https://github.com/masterzen/nginx-upload-progress-module/tarball/v#{upload_progress_version}"
  action :create_if_missing
end

bash "extract_upload_progress_module" do
  cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
    mkdir nginx-upload-progress-module-v#{upload_progress_version}
    tar xzf nginx-upload-progress-module-v#{upload_progress_version}.tar.gz -C nginx-upload-progress-module-v#{upload_progress_version}
    mv nginx-upload-progress-module-v#{upload_progress_version}/*/* nginx-upload-progress-module-v#{upload_progress_version}/
  EOH
  not_if do File.exists?("#{Chef::Config[:file_cache_path]}/nginx-upload-progress-module-v#{upload_progress_version}") end
end

service "nginx" do
  action :nothing
end

cookbook_file "#{node[:nginx][:dir]}/conf.d/upload_progress.conf" do
  source "upload_progress.conf"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "nginx")
end

node.set[:nginx][:configure_flags] = 
  node[:nginx][:configure_flags] | ["--add-module=#{Chef::Config[:file_cache_path]}/nginx-upload-progress-module-v#{upload_progress_version}"]
  
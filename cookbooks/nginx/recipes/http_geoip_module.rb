#
# Cookbook Name:: nginx
# Recipe:: http_geoip_module
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
  node[:nginx][:configure_flags] | ["--with-http_geoip_module"]

geoip_path = "/srv/geoip"
node.default[:nginx][:geoip][:country_dat] = country_dat = "#{geoip_path}/GeoIP.dat"
node.default[:nginx][:geoip][:city_dat] = city_dat = "#{geoip_path}/GeoLiteCity.dat"

node.default[:nginx][:geoip][:enable_city] = false

package "libgeoip-dev"

directory "#{geoip_path}" do
  owner "root"
  group "root"
  mode 0755
end

remote_file "#{geoip_path}/GeoLiteCity.dat.gz" do
  source "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz"
  owner "root"
  group "root"
  mode 0644
  action :create_if_missing
end

remote_file "#{geoip_path}/GeoIP.dat.gz" do
  source "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz"
  owner "root"
  group "root"
  mode 0644
  action :create_if_missing
end

bash "gunzip_geo_lite_city_dat" do
  cwd "#{geoip_path}"
  code <<-EOH
    gunzip -c GeoLiteCity.dat.gz > #{File.basename(city_dat)}
  EOH
  creates city_dat
end

bash "gunzip_geo_lite_country_dat" do
  cwd "#{geoip_path}"
  code <<-EOH
    gunzip -c GeoIP.dat.gz > #{File.basename(country_dat)}
  EOH
  creates country_dat
end

template "#{node[:nginx][:dir]}/conf.d/http_geoip.conf" do
  source "http_geoip.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

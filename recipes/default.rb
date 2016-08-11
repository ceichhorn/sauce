#
# Cookbook Name:: sauceconnect
# Recipe:: default
#
# Copyright 2012-2013, SecondMarket Labs, LLC
# Copyright 2013-2015, Chef Software, Inc.
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

include_recipe 'gdp-base-linux'
include_recipe 'ark'

user node['sauceconnect']['server']['user'] do
  comment 'SauceLabs Proxy User'
  action :create
  home node['sauceconnect']['server']['install_dir']
end

directory node['sauceconnect']['server']['install_dir'] do
  owner node['sauceconnect']['server']['user']
  mode 0755
  action :create
end

# download the file

ark 'sauceconnect' do
  url "#{node['sauceconnect']['server']['download_url']}/#{node['sauceconnect']['server']['tarball']}"
  path "/opt"
  action :put
  owner node['sauceconnect']['server']['user']
end

template "#{node['sauceconnect']['server']['install_dir']}/sauceconnect.conf" do
  source 'sauceconnect.sysconfig.erb'
  mode 00644
  owner node['sauceconnect']['server']['user']
  group 'root'
  action :create
  notifies :restart, 'service[sauceconnect]'
end

# include s3 config fetcher recipe prior to restart
include_recipe 'sauceconnect::s3_config_fetcher' if node['sauceconnect']['config-from-s3']

template '/etc/init.d/sauceconnect' do
  source 'sauceconnect.init.erb'
  mode 00755
  owner 'root'
  group 'root'
  action :create
end



service 'sauceconnect' do
  supports :restart => true
  action [:enable, :start]
end

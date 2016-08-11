#
# Cookbook Name:: sauceconnect
# Recipe:: s3-config-fetcher
#
# Copyright (C) 2016 Gannett
#
# All rights reserved - Do Not Redistribute
#

include_recipe 's3cmd'

config_fetcher_script = "#{node['sauceconnect']['server']['install_dir']}/s3-config-fetcher.sh"
config_fetcher_log_redirect = '2>&1 | logger'
config_fetcher_command = "#{config_fetcher_script} #{config_fetcher_log_redirect}"
config_fetcher_reloading_command = "#{config_fetcher_script} reload #{config_fetcher_log_redirect}"
s3_config = "#{node['sauceconnect']['server']['install_dir']}/.s3cfg"

# create s3cfg if testing
template s3_config do
  source 's3-config.erb'
  mode 0755
  owner node['sauceconnect']['server']['user']
  only_if { node['sauceconnect']['s3']['test_config'] }
end

# setup config
template config_fetcher_script do
  source 's3-config-fetcher.erb'
  mode 0755
  owner node['sauceconnect']['server']['user']
end

# execute config
execute 's3-config-command' do
  command "su #{node['sauceconnect']['server']['user']} -l -c '#{config_fetcher_command}'"
  user 'root'
end

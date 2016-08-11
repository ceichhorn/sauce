#
# Cookbook Name:: sauceconnect
# Spec:: default
#
# Copyright (c) 2016 Gannett Co., Inc, All Rights Reserved.

require 'spec_helper'


describe 'sauceconnect::default' do
  context 'When all attributes are default, on centos' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.1.1503') do |node|
        Chef::Config[:client_key] = "/etc/chef/client.pem"
        node.set['sauceconnect']['server']['install_dir'] = '/opt/sauceconnect'
        node.set['sauceconnect']['server']['version'] = '4.3.16'
        stub_command("which sudo").and_return('/usr/bin/sudo')
        node.set['authorization']['sudo']['groups'] = ["admin", "wheel", "test"]
        node.set['ssh_keys'] = ''
        node.default['ssh_keys'] = { test: ["test"] }
      end.converge(described_recipe)
    end
    # included recipes
    recipe_list = ['gdp-base-linux']

    recipe_list.each do |name|
      it 'includes the recipe ' + name do
        expect(chef_run).to include_recipe(name)
      end
    end

    it 'creates sauceconnect user' do
      expect(chef_run).to create_user('sauceprx')
    end

    directory_list = ['/opt/sauceconnect']
    directory_list.each do |name|
      it 'creates '+ ' directory' do
        expect(chef_run).to create_directory(name)
      end
    end

    it 'downloads app file' do
      expect(chef_run).to create_remote_file('/tmp/sc-4.3.16-linux.tar.gz')
    end

    it 'does not run unzip-saucelabs-proxy' do
      expect(chef_run).to_not run_bash('unzip-saucelabs-proxy')
    end

    it 'creates the sauceconnect init file' do
      expect(chef_run).to create_template('/etc/init.d/sauceconnect')
    end

     it 'creates the sauceconnect config file' do
      expect(chef_run).to create_template('/opt/sauceconnect/sauceconnect.conf')
    end

    it 'executes both actions' do
      expect(chef_run).to start_service('sauceconnect')
    end

  end

end

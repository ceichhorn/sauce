# chef-sauceconnect

This cookbook sets up a VM to serve a ruby app using Nginx and Passenger.  Ruby is installed using RVM.

Centos 7.1 is required for Passenger to be installed via package and not require Nginx to be recompiled.  Nginx 1.8 is supported on Centos 7.1.

## Supported Platforms

- ~~Centos 6.x~~ **not supported!**
- Centos 7.1

## Attributes

Key | Type | Description | Default
--- | ---- | ----------- | -------
['sauceconnect']['server']['version'] | String | Version to install | 4.3.16
['sauceconnect']['server']['download_url'] | String |  URL where the app can be found | http://saucelabs.com/downloads
['sauceconnect']['server']['tarball']| String | Complete tarball name | sc-#{node['sauceconnect']['server']['version']}-linux.tar.gz
['sauceconnect']['server']['install_dir'] | String | Default install directory | /opt/sauceconnect
['sauceconnect']['server']['user'] | String | Name of Sauce Connect user| sauceprx
['sauceconnect']['server']['log_file'] | String | Where to log | #{node['sauceconnect']['server']['install_dir']}/sauceconnect.log
['sauceconnect']['server']['pid_file'] | String | Pid file location | /var/run/sauceconnect.pid
['sauceconnect']['server']['app_env'] | String | Environment you are in | development

['sauceconnect']['server']['api_user'] | String | Sauce Connect client name | test
['sauceconnect']['server']['api_key'] | String | API key for your | test

['sauceconnect']['config-from-s3'] | String | S3 bucket with your Sauce Connect config | false
['sauceconnect']['s3-config-bucket'] | String |  nil
default['sauceconnect']['configuration_files']| String | nil


### Notes
# configuration_files example
# ["'#{node['ruby-deployment']['application']['name']}-
# {node['ruby-deployment']['application']['app_env']}-sauceconnect.conf',


## Usage

### sauceconnect::default

The default recipe will install the Sauce Connect client and try to connect to Sauce Labs.

Include `sauceconnect` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[sauceconnect::default]"
  ]
}
```

```

## License and Authors

Author:: Gannett Paas Delivery (<devops@gannett.com>)

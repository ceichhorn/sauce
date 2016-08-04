name 'sauceconnect'
maintainer 'Gannett Co., Inc'
maintainer_email 'paas-delivery@gannett.com'
license ' Copyright (c) 2016 Gannett Co., Inc, All Rights Reserved.'
description 'Installs/Configures sauceconnect'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

# add any cookbook dependencies here
depends 'gdp-base-linux', '>= 2.0.7'

supports 'centos'

source_url 'https://github.com/GannettDigital/chef-sauceconnect'
issues_url 'https://github.com/GannettDigital/chef-sauceconnect/issues'

name             'deploy_permissions'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures deploy_permissions'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "acl"
recommends "apache2"
recommends "supervisor"
recommends "sudo"

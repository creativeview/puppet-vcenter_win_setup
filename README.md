# VMware vCenter 5.5 Windows Installation module for Puppet #

### Module Description

This module deploys VMware vCenter 5.5 on Windows and it's components using a MSSQL database. The components can be separated out on to different servers if required.  

#### Components it installs
* VMware vCenter Single Sign-On
* VMware vCenter Inventory Service
* VMware vCenter 
* VMware vCenter Orchestrator
* VMware vSphere Client 5.5
* VMware vSphere Web Client

The module was written using the VMware "[Command-Line Installation and Upgrade of VMware vCenter Server 5.5] (http://www.vmware.com/files/pdf/techpaper/vcenter_server_cmdline_install.pdf)" as a guide. Please reference this to understand what parameters the module uses: http://www.vmware.com/files/pdf/techpaper/vcenter_server_cmdline_install.pdf

The module has been tested with MS SQL 2008 and MS SQL 2012 on a standalone VMware vCenter server installation.  During testing all components have installed in around 18 minutes. 

## Installation

```bash
puppet module install creativeview-vcenter_win_setup
```
This module depends on DISM module to enable .net 3.5 on Windows Server:

* [dism module] (http://forge.puppetlabs.com/puppetlabs/dism)

It's recommended to use the [mssql_system_dsn] (https://forge.puppetlabs.com/creativeview/mssql_system_dsn) module to setup the ODBC System DSN.

## Usage
The puppet run should be started using "Run Puppet Agent". Running the installation via the Puppet service will cause errors during the installation. 

##### Example:

```puppet
class {'mssql_system_dsn':
        dsn_name => 'vcenter',
        db_name => 'vcenter',
        db_server_ip => '10.10.78.24',
        sql_version => '2008',
        dsn_64bit => true,
}

class{'vcenter_win_setup':
}

class{'vcenter_win_setup::msvc2005':
 media => 'C:\Software\VMware\vCenter 5.5a\\',
}

class{'vcenter_win_setup::set_logon_as_service':
 account => 'domain\administrator',
}

class{'vcenter_win_setup::sso':
        require => [Class["vcenter_win_setup::msvc2005"],Class["mssql_system_dsn"]],
        media => 'C:\Software\VMware\vCenter 5.5a\\',
        sso_pwd => 'Pa$$word',
        sso_deploymode => 'FIRSTDOMAIN',
        sso_site => 'TestSite',
 }

class{'vcenter_win_setup::inventory_service':
        require => Class["vcenter_win_setup::sso"],
        media => 'C:\Software\VMware\vCenter 5.5a\\',
        sso_pwd => 'Pa$$word',
        sso_admin => 'administrator@vsphere.local',
        vcenterIPAddress => 'vcenteraddress.domain.local',
        inventoryService_query_service_nuke_database => '1',
 }

class{'vcenter_win_setup::vcenter':
        require => [Class["vcenter_win_setup::inventory_service"],Class["vcenter_win_setup::set_logon_as_service"]],
        media => 'C:\Software\VMware\vCenter 5.5a\\',
        sso_pwd => 'Pa$$word',
        sso_admin => 'administrator@vsphere.local',
        vcenterIPAddress => 'vcenteraddress.domain.local',
        vc_ADMIN_USER => 'administrator@vsphere.local',
        db_DSN => 'vCenter',
        vCenter_FORMAT_DB => '1',
        vpx_ACCOUNT => 'domain\administrator',
        vpx_PASSWORD => 'Pa$$word',
 }

class{'vcenter_win_setup::client':
        require => Class["vcenter_win_setup::vcenter"],
        media => 'C:\Software\VMware\vCenter 5.5a\\',
 }

class{'vcenter_win_setup::webclient':
        require => Class["vcenter_win_setup::client"],
        media => 'C:\Software\VMware\vCenter 5.5a\\',
        vcenterIPAddress => 'vcenteraddress.domain.local',
        sso_pwd => 'Pa$$word',
        sso_admin => 'administrator@vsphere.local',
 }
```

## Full list of parameters 

#### vcenter_win_setup::set_logon_as_service
* account - Account to add logon as service rights. Used for the vCenter service. 

#### vcenter_win_setup::msvc2005
* media - location of installation media

#### vcenter_win_setup::sso
* media - location of installation media
* sso_pwd
* sso_deploymode
* sso_site
* sso_httpport

#### vcenter_win_setup::inventory_service
* media - location of installation media
* sso_pwd
* sso_httpport
* sso_admin
* vcenterIPAddress
* inventoryService_https_port
* inventoryService_query_service_nuke_database
* inventoryService_xdb_port
* inventoryService_federation_port
* inventoryService_tomcat_max_memory_option

#### vcenter_win_setup::vcenter
* media - location of installation media
* sso_pwd,
* sso_httpport
* sso_admin
* vcenterIPAddress
* vc_ADMIN_USER
* vCenter_FORMAT_DB
* vCenter_JVM_MEMORY_OPTION
* db_DSN
* vpx_ACCOUNT
* vpx_PASSWORD
* vcenter_VCS_HTTP_PORT
* vcenter_VCS_HTTPS_PORT
* vcenter_VCS_HEARTBEAT_PORT
* vcenter_TC_HTTP_PORT
* vcenter_TC_HTTPS_PORT
* vcenter_VCS_ADAM_LDAP_PORT
* vcenter_VCS_ADAM_SSL_PORT

#### vcenter_win_setup::client
* media - location of installation media

#### vcenter_win_setup::webclient
* media - location of installation media
* vcenterIPAddress
* sso_pwd
* sso_httpport
* sso_admin
* webclient_HTTP_PORT
* webclient_HTTPS_PORT

#### Development 
* Further contributions and feedback is welcomed - please submit a pull request or issue on GitHub.
# Class: vcenter_win_setup::sso
#
# This module manages vCenter 5.5 Windows SSO installation
#
# Actions:
#
# Requires: see Modulefile
#
class vcenter_win_setup::vcenter (
  $media = 'D:\\',
  $sso_pwd,
  $sso_httpport = '7444',
  $sso_admin,
  $vcenterIPAddress,  
	$vc_ADMIN_USER,
	$vCenter_FORMAT_DB = '0',
	$vCenter_JVM_MEMORY_OPTION = 'S',
	$db_DSN,
	$vpx_ACCOUNT,
	$vpx_PASSWORD,
	$vcenter_VCS_HTTP_PORT = '80',
	$vcenter_VCS_HTTPS_PORT = '443',
	$vcenter_VCS_HEARTBEAT_PORT = '902',
	$vcenter_TC_HTTP_PORT = '8080',
	$vcenter_TC_HTTPS_PORT = '8443',
	$vcenter_VCS_ADAM_LDAP_PORT = '389',
	$vcenter_VCS_ADAM_SSL_PORT = '902',
)
{
 
 $product_name = "VMware vCenter Server"
 $setup_cmd = "\"${media}vCenter-Server\VMware-vcserver.exe\" /w /L1033 /v\"/qr SSO_ADMIN_USER=\\\"${sso_admin}\\\" SSO_ADMIN_PASSWORD=\\\"${sso_pwd}\\\" LS_URL=\\\"https://${vcenterIPAddress}:${sso_httpport}/lookupservice/sdk\\\" VC_ADMIN_USER=\\\"${vc_ADMIN_USER}\\\" DB_SERVER_TYPE=Custom DB_DSN=\\\"${db_DSN}\\\"  DB_DSN_WINDOWS_AUTH=1 FORMAT_DB=${vCenter_FORMAT_DB} JVM_MEMORY_OPTION=${vCenter_JVM_MEMORY_OPTION} VPX_USES_SYSTEM_ACCOUNT=\\\"\\\" VPX_ACCOUNT=\\\"${vpx_ACCOUNT}\\\" VPX_PASSWORD=\\\"${vpx_PASSWORD}\\\" VPX_PASSWORD_VERIFY=\\\"${vpx_PASSWORD}\\\" VCS_GROUP_TYPE=Single VCS_HTTPS_PORT=${vcenter_VCS_HTTPS_PORT} VCS_HTTP_PORT=${vcenter_VCS_HTTP_PORT} VCS_HEARTBEAT_PORT=${vcenter_VCS_HEARTBEAT_PORT} TC_HTTP_PORT=${vcenter_TC_HTTP_PORT} TC_HTTPS_PORT=${vcenter_TC_HTTPS_PORT} VCS_ADAM_LDAP_PORT=${vcenter_VCS_ADAM_LDAP_PORT} VCS_ADAM_SSL_PORT=${vcenter_VCS_ADAM_SSL_PORT} /L*v \"%TEMP%\vmvcsvr.log\" \""
 

 file { 'C:\\vCenter_Setup_Scripts\vcenter_setup.bat':
    content => template('vcenter_win_setup/setup.bat.erb'),
  }

  exec { 'install_vcenter':
    command   => "C:\\vCenter_Setup_Scripts\\vcenter_setup.bat",
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
require   => [ File['C:\\vCenter_Setup_Scripts\vcenter_setup.bat'],
                   Dism['NetFx3'] ],
  }

}

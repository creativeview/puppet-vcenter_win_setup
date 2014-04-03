# Class: vcenter_win_setup::webclient
#
# This module manages vCenter 5.5 Windows Web Client Server Installation
#
# Actions:
#
# Requires: see Modulefile
#
class vcenter_win_setup::webclient (
  $media = 'D:\\',
  $vcenterIPAddress,
  $sso_pwd,
  $sso_httpport = '7444',
  $sso_admin,
  $webclient_HTTP_PORT = '9090',
  $webclient_HTTPS_PORT = '9443',
)
{
 
 $product_name = "VMware vSphere Web Client"
 $setup_cmd = "\"${media}vSphere-WebClient\VMware-WebClient.exe\" /w /L1033 /v\"/qr HTTP_PORT=${webclient_HTTP_PORT} HTTPS_PORT=${webclient_HTTPS_PORT} SSO_ADMIN_USER=\\\"${sso_admin}\\\" SSO_ADMIN_PASSWORD=\\\"${sso_pwd}\\\" LS_URL=\\\"https://${vcenterIPAddress}:${sso_httpport}/lookupservice/sdk\\\" /L*v \"%TEMP%\vim-qs-msi.log\""
 

 file { 'C:\\vCenter_Setup_Scripts\webclient_setup.bat':
    content => template('vcenter_win_setup/setup.bat.erb'),
  }

  exec { 'install_webclient':
    command   => "C:\\vCenter_Setup_Scripts\\webclient_setup.bat",
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
require   => [ File['C:\\vCenter_Setup_Scripts\webclient_setup.bat'],
                   Dism['NetFx3'] ],
  }

}

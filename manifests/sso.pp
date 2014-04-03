# Class: vcenter_win_setup::sso
#
# This module manages vCenter 5.5 Windows SSO installation
#
# Actions:
#
# Requires: see Modulefile
#
class vcenter_win_setup::sso (
  $media = 'D:\\',
  $sso_pwd,
  $sso_deploymode = 'FIRSTDOMAIN',
  $sso_site,
  $sso_httpport = '7444',
)
{

 $product_name = "vCenter Single Sign-On"
 $setup_cmd = "start /wait msiexec.exe /qr /norestart /i  /L*v \"%TEMP%\vim-sso-msi.log\" \"${media}Single Sign-On\VMware-SSO-Server.msi\" SSO_HTTPS_PORT=${sso_httpport} DEPLOYMODE=${sso_deploymode} ADMINPASSWORD=${sso_pwd} SSO_SITE=${sso_site} "

  file { 'C:\\vCenter_Setup_Scripts\sso_setup.bat':
    content => template('vcenter_win_setup/setup.bat.erb'),
  }

  exec { 'install_sso':
    command   => "C:\\vCenter_Setup_Scripts\\sso_setup.bat",
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
require   => [ File['C:\\vCenter_Setup_Scripts\sso_setup.bat'],
                   Dism['NetFx3'] ],
  }


}

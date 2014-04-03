# Class: vcenter_win_setup::client
#
# This module manages vCenter 5.5 Windows vSphere Client Installation
#
# Actions:
#
# Requires: see Modulefile
#
class vcenter_win_setup::client (
  $media = 'D:\\',
)
{
 
 $product_name = "VMware vSphere Client 5.5"
  $setup_cmd = "\"${media}vSphere-Client\VMware-viclient.exe\" /w /L1033 /v\"/qr /L*v \"%TEMP%\vim-vic-msi.log\""

 file { 'C:\\vCenter_Setup_Scripts\client_setup.bat':
    content => template('vcenter_win_setup/setup.bat.erb'),
  }

  exec { 'install_client':
    command   => "C:\\vCenter_Setup_Scripts\\client_setup.bat",
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
require   => [ File['C:\\vCenter_Setup_Scripts\client_setup.bat'],
                   Dism['NetFx3'] ],
  }

}

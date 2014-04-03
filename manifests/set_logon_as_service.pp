# Class: vcenter_win_setup::set_logon_as_service
#
# This module manages Logon As A Service Rights
#
# Actions:
#
# Requires: 
#
#
class vcenter_win_setup::set_logon_as_service (
  $account,
)
{
 
  file { 'C:\\vCenter_Setup_Scripts\SetLogonAsAServiceRight.vbs':
    content => template('vcenter_win_setup/SetLogonAsAServiceRight.vbs.erb'),
  }

  exec { 'setLogonAsAServiceRight':
    command   => "cscript.exe C:\\vCenter_Setup_Scripts\\SetLogonAsAServiceRight.vbs",
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
    require   => [ File['C:\\vCenter_Setup_Scripts\SetLogonAsAServiceRight.vbs']],
  }

  
}

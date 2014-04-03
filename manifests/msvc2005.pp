# Class: vcenter_win_setup::msvc2005
#
# This module manages vCenter 5.5 Windows msvc2005 installation
#
# Actions:
#
# Requires: see Modulefile
#
#
class vcenter_win_setup::msvc2005 (
  $media = 'D:\\',
)
{
 $product_name = "Microsoft Visual C++ 2005 Redistributable"
 $setup_cmd = "\"${media}redist\vcredist\2005\vcredist_x86.exe\" /q" 

  file { 'C:\\vCenter_Setup_Scripts\msvc2005_setup.bat':
    content => template('vcenter_win_setup/setup.bat.erb'),
  }

  exec { 'install_msvc2005':
    command   => "C:\\vCenter_Setup_Scripts\\msvc2005_setup.bat",
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
    require   => [ File['C:\\vCenter_Setup_Scripts\msvc2005_setup.bat'],
                   Dism['NetFx3'] ],
  } 
}

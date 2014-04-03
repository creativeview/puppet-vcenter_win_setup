# Class: vcenter_win_setup
#
# This module manages vcenter
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class vcenter_win_setup {
  
  dism { 'NetFx3':
    ensure => present,
  }
  
  file { "C:\\vCenter_Setup_Scripts":
    ensure => "directory",
  }
  
}

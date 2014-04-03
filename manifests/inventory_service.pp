# Class: vcenter_win_setup::inventory_service
#
# This module manages VMware vCenter Inventory Service installation
#
# Actions:
#
# Requires: see Modulefile
#
class vcenter_win_setup::inventory_service (
  $media = 'D:\\',
  $sso_pwd,
  $sso_httpport = '7444',
  $sso_admin,
  $vcenterIPAddress,
  $inventoryService_https_port = '10443',
  $inventoryService_query_service_nuke_database = '0',
  $inventoryService_xdb_port = '10109',
  $inventoryService_federation_port = '10111',
  $inventoryService_tomcat_max_memory_option = 'S',
)
{
 
 $product_name = "VMware vCenter Inventory Service" 
 
 $setup_cmd = "\"${media}inventory Service\VMware-inventory-service.exe\" /S /L1033 /v\"/qr QUERY_SERVICE_NUKE_DATABASE=${inventoryService_query_service_nuke_database} SSO_ADMIN_USER=\\\"${sso_admin}\\\" SSO_ADMIN_PASSWORD=\\\"${sso_pwd}\\\" LS_URL=\\\"https://${vcenterIPAddress}:${sso_httpport}/lookupservice/sdk\\\" HTTPS_PORT=${inventoryService_https_port} FEDERATION_PORT=${inventoryService_federation_port} XDB_PORT=${inventoryService_xdb_port} TOMCAT_MAX_MEMORY_OPTION=${inventoryService_tomcat_max_memory_option} /L*v \"%TEMP%\vim-qs-msi.log\" \""
        
   file { 'C:\\vCenter_Setup_Scripts\inventory_service_setup.bat':
    content => template('vcenter_win_setup/setup.bat.erb'),
  }
 
  exec { 'install_inventory_service':
    command   => 'C:\\vCenter_Setup_Scripts\\inventory_service_setup.bat',
    path      => 'c:\windows\system32;c:\windows',
    logoutput => true,
    timeout   => 1200,
    require   => [ File['C:\\vCenter_Setup_Scripts\inventory_service_setup.bat'],
                   Dism['NetFx3'] ],
  }
   
}

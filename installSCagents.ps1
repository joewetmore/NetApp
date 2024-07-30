#open a connection to the SnapCenter server
open-smconnection -smsbaseurl https://c1ssc01.ccp1.gene.com:8146


#install and configure the SnapCenter agent on a standalone sql server

$sqlhost1 = 'sqltest01'
$RGname = 'RG_TESTSQL1_12H'

Add-SmHost -hostname $sqlhost1".ccp1.gene.com" -hosttype windows -donotaddclusternodes -credentialname ccp1jthein
Install-SmHostPackage -hostnames @("$sqlhost1.ccp1.gene.com") -plugincodes SCSQL,SCW -GMSAName 'CCP1\svcSnapCenter$'

#wait until plugin installation is complete

Set-SmPluginConfiguration -PluginCode SCSQL -HostName $sqlhost1".ccp1.gene.com" -HostLogFolders @{"Host"="$sqlhost1.ccp1.gene.com";"Log Folder"="E:\SCLOGS"} -Confirm:$false

#add the host to a resource group (note: this replaces existing resources in the RG)
Set-SmResourceGroup -ResourceGroupName RG_TESTSQL1_12H -Resources @{"Host"="$sqlhost1".ccp1.gene.com;"Type"="SQL Instance";"Names"="$sqlhost1"} -PluginCode SCSQL

#note: this adds multiple resources to a RG
Set-SmResourceGroup -ResourceGroupName RG_TESTSQL1_12H `
   -Resources `
   @{"Host"="sqltest01.ccp1.gene.com";"Type"="SQL Instance";"Names"="sqltest01"}, `
   @{"Host"="sqltest02.ccp1.gene.com";"Type"="SQL Instance";"Names"="sqltest02"}, `
   @{"Host"="sqltest03.ccp1.gene.com";"Type"="SQL Instance";"Names"="sqltest03"} `
   -PluginCode SCSQL



#install and configure the SnapCenter agent on a cluster

$sqlChost1 = 'sqltest02'
$sqlChost2 = 'sqltest03'
$sqlClusterName = 'sqltestc'
$RGname = 'RG_TESTSQL1_12H'

Add-SmHost -hostname $sqlClusterName".ccp1.gene.com" -hosttype windows -donotaddclusternodes -credentialname ccp1jthein
Install-SmHostPackage -hostnames @("sqlChost1.ccp1.gene.com", "sqlChost2.ccp1.gene.com") -plugincodes SCSQL,SCW -GMSAName 'CCP1\svcSnapCenter$'

#wait until plugin installation is complete

Set-SmPluginConfiguration -PluginCode SCSQL -HostName "sqlClusterName".ccp1.gene.com -HostLogFolders @{"Host"="sqlChost1.ccp1.gene.com";"Log Folder"="E:\SCLOGS"},@{"Host"="sqlChost2.ccp1.gene.com";"Log Folder"="E:\SCLOGS"} -Confirm:$false



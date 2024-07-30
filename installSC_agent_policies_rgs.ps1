 # Verify administrator
if ( -not (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).
    IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) ) {
    throw 'Run as an administrator'
}

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


$PolicyName = "12h_backup_"

Add-SmPolicy `
  -PolicyName 12h_backup_ `
  -PolicyType Backup `
  -PluginPolicyType SMSQL `
  -RetentionSettings @{"BackupType"="DATA";"ScheduleType"="DAILY";"RetentionCount"='30'} `
  -Description 'SQL daily schedule policy' `
  -UtmType DayBase `
  -UtmDays 7 `
  -SqlBackupType FullBackupAndLogBackup `
  -VerifyLogBackup $true `
  -ScheduleType Daily 


  Add-SmResourceGroup `
  -ResourceGroupName "RG_TESTSQL2_12H" `
  -PluginCode SCSQL `
  -Resources @{"Host"="sqltest01.ccp1.gene.com";"Type"="SQL Instance";"Names"="sqltest01"} `
  -Policies "12h_backup_" `
  -VerificationServers "sqltest01" `
  -VerificationSchedules @{"VerificationType"="VERIFY_AFTER_BACKUP";"VerificationServers"="sqltest01";"BackupPolicyName"="12h_backup_";"ScheduleType"="daily";"BackupScheduleType"="daily"} `
  -Schedules @{"PolicyName"="12h_backup_";"ScheduleType"="Daily";"StartTime"=" 07/30/2024 4:00PM";"daysInterval"="1"} 
 

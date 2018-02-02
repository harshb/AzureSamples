

##################################################################################
# Param
##################################################################################

param (

[Parameter(Mandatory=$true)]
$Location,

[Parameter(Mandatory=$true)]
$ProjectName,

[Parameter(Mandatory=$true)]
$ResourceGroupName,


[Parameter(Mandatory=$true)]
$AdminUsername,

[Parameter(Mandatory=$true)]
$AdminPassword


)


<#
Example
$Location ="eastus"
$ProjectName = "abc"
$ResourceGroupName = "rg-temp"
$AdminUsername ="hersh"
$AdminPassword = "x"
#>

##################################################################################
# Connect
##################################################################################
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint


########################################################
## sql dwh
########################################################

$SQLServerName = $ProjectName + "SqlServer"
$SQLDatabaseName = $ProjectName + "db"

$DWU = "DW100";

$SQLServerSecurePassword = ConvertTo-SecureString –String $AdminPassword –AsPlainText -Force

$SQLServerCreds = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $AdminUsername, $SQLServerSecurePassword

#SQL server
$TenantSQLServer = New-AzureRmSqlServer -ResourceGroupName $ResourceGroupName -ServerName $SQLServerName -Location $Location -ServerVersion "12.0" -SqlAdministratorCredentials $SQLServerCreds
  
#sql data warehouse

$TenantSQLDW = New-AzureRmSqlDatabase -RequestedServiceObjectiveName $DWU -DatabaseName $SQLDatabaseName -ServerName $TenantSQLServer.ServerName -ResourceGroupName $ResourceGroupName -Edition "DataWarehouse"
    
#encryption
Set-AzureRMSqlDatabaseTransparentDataEncryption -ServerName $TenantSQLServer.ServerName -ResourceGroupName $ResourceGroupName -DatabaseName $TenantSQLDW.DatabaseName -State "Enabled"  

#check
 $TDE = Get-AzureRmSqlDatabaseTransparentDataEncryption -ServerName $TenantSQLServer.ServerName -ResourceGroupName $ResourceGroupName -DatabaseName $TenantSQLDW.DatabaseName


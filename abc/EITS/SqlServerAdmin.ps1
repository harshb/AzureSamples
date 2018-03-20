
Import-AzureRmContext -Path "c:\temp\azureprofile.json"
#Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName "Provider Solutions Development"


$ResourceGroup = ""
$SQLServerName = ""

########################################################
#  Add Admin Group to  SQL Server
########################################################

Set-AzureRmSqlServerActiveDirectoryAdministrator –ResourceGroupName $ResourceGroup  –ServerName $SQLServerName -DisplayName  $AdminGroup
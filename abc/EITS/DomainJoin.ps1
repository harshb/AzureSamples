﻿$VmName ="abcVM0"
$ResourceGroupName = "rg-test-vm1"
$Location ="eastus2" 
$DomainName ="abc.amerisourcebergen.com"
$DomainJoinAdminName ="abc\prd_sps_auto_job"
$DomainJoinPassword ="KxE5y3odbN3Dd3*"
$OU = "OU=SPSServers,OU=Production,OU=ABCServers,DC=abc,DC=amerisourcebergen,DC=com"

#Login-AzureRmAccount
Import-AzureRmContext -Path "c:\temp\azureprofile.json"
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName "Provider Solutions Development"


Set-AzureRmVMExtension -VMName $VmName -ResourceGroupName $ResourceGroupName -Name "JoinAD" -ExtensionType  "JsonADDomainExtension" `
-Publisher "Microsoft.Compute" -TypeHandlerVersion "1.0" -Location $Location `
-Settings @{"Name" = $DomainName; "User" = $DomainJoinAdminName; "Restart" = "true"; "Options" = 3;"OUPath" = $OU;} -ProtectedSettings @{ "Password" = $DomainJoinPassword} 

#Remove-AzureRmVMExtension -ResourceGroupName $ResourceGroupName -Name "JoinAD" -VMName $VmName


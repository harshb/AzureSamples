

$VmName ="abcVM0"
$ResourceGroupName = "rg-test-vm"
$Location ="eastus2" 


Import-AzureRmContext -Path "c:\temp\azureprofile.json"
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName "Provider Solutions Development"

Set-AzureRmVMSqlServerExtension -ResourceGroupName $ResourceGroupName -VMName $VmName -Name "SQLIaasExtension" -Version "1.2" -Location $Location
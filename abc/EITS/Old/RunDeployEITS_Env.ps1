.\EITS2_DeployEITS_Env.ps1 -Location "eastus2"  -ProjectName "xyz" -ResourceGroupName "rg-xyz" -VnetAddressPrefix "10.0.0.0/16" -SubnetAddressPrefix "10.0.2.0/24"  -PrivateIPAddress "10.0.2.6"`
 -AdminUsername  "slalomadmin" -AdminPassword "!Race2Win!" -NumberOfInstances 1 `
 -RegistrationKey "vodkg69IELV9ZiEk1pHmVBCopM74dh9fnaDh6cxz5xQf5yo3AnBKIEz8iNQ8halomqHw1z50/9wHXs4WIp8qEw==" `
 -RegistrationUrl "https://eus2-agentservice-prod-1.azure-automation.net/accounts/3b99d5ea-c740-42b2-b805-3f63089bce90" `
 -NodeConfigurationName "DefaultServerConfig" `
 -TemplateFile "https://infraautomationstorage.blob.core.windows.net/infraautomationstoragecontainer/LoadBalancedVirtualMachine.json"


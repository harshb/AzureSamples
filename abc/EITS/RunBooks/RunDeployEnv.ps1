.\DeployEnv.ps1 -Location "eastus2"  -ProjectName "abc" -ResourceGroupName "rg-test-vm" `
 -AdminUsername  "abcadmin" -AdminPassword "!Race2Win!" -NumberOfInstances 1 `
 -RegistrationKey "vodkg69IELV9ZiEk1pHmVBCopM74dh9fnaDh6cxz5xQf5yo3AnBKIEz8iNQ8halomqHw1z50/9wHXs4WIp8qEw==" `
 -RegistrationUrl "https://eus2-agentservice-prod-1.azure-automation.net/accounts/3b99d5ea-c740-42b2-b805-3f63089bce90" `
 -NodeConfigurationName "DefaultServerConfig.localhost" `
 -TemplateFile "https://infraautomationstorage.blob.core.windows.net/infraautomationstoragecontainer/LoadBalancedVirtualMachine_SqlServer.json"`
 -VirtualNetworkResourceGroup "its-core-networking" -VirtualNetworkSubnetName "SSRS" -virtualNetworkName "its-core-vnet" `
 -WorkspaceId "d15cc976-02c0-4c93-bbe6-95ecd5b0b308" `
 -WorkspaceKey  "Av7Ya4DMwf1A7tYZEBIYe2ns94jugHsFPYtrdWsi1e6Pz53z9azR5qiGxRKNq/8vMaVAssN71wyrH2GXIZZsvQ==" `
 -DomainToJoin  "abc.amerisourcebergen.com" -DomainUsername  "abc\prd_sps_auto_job" -DomainPassword  "KxE5y3odbN3Dd3*"




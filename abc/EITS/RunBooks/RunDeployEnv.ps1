.\DeployEnv.ps1 -Location "eastus2"  -ProjectName "abc" -ResourceGroupName "its-test-deploy-vm2" `
 -AdminUsername  "abcadmin" -AdminPassword "!Race2Win!" -NumberOfInstances 1 `
 -RegistrationKey "Q/CAEeU81qdAtkNSlWD8JEtR0mlTQ77EJ0ZyVg9sZz3X++GG3ecfgIt4TLYJ+qO/PlUfiw2Of7D/D7GEgz5ybw==" `
 -RegistrationUrl "https://eus2-agentservice-prod-1.azure-automation.net/accounts/bbb9866d-02f5-4388-aa1c-e273991e5839" `
 -NodeConfigurationName "DefaultServerConfig.localhost" `
 -TemplateFile "https://infraautomationstorage.blob.core.windows.net/infraautomationstoragecontainer/LoadBalancedVirtualMachine_ExistingVNet.json"`
 -VirtualNetworkResourceGroup "its-core-networking" -VirtualNetworkSubnetName "SSRS" -virtualNetworkName "its-core-vnet"




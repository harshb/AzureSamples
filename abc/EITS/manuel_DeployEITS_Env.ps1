##################################################################################
# Instructions
##################################################################################
#Import module from marketplace in automation account : AzureRM.Profile, AzureRM.Network

##################################################################################
# Param
##################################################################################
<#
param (

[Parameter(Mandatory=$true)]
$Location,

[Parameter(Mandatory=$true)]
$ProjectName,

[Parameter(Mandatory=$true)]
$ResourceGroupName,

[Parameter(Mandatory=$true)]
$VnetAddressPrefix,

[Parameter(Mandatory=$true)]
$SubnetAddressPrefix,

[Parameter(Mandatory=$true)]
$PrivateIPAddress,

[Parameter(Mandatory=$true)]
$AdminUsername,

[Parameter(Mandatory=$true)]
$AdminPassword,

[Parameter(Mandatory=$true)]
[int]
$NumberOfInstances,

[Parameter(Mandatory=$true)]
$RegistrationKey,

[Parameter(Mandatory=$true)]
$RegistrationUrl,

[Parameter(Mandatory=$true)]
$NodeConfigurationName,

[Parameter(Mandatory=$true)]
$TemplateFile,

[Parameter(Mandatory=$true)]
$VirtualNetworkResourceGroup,

[Parameter(Mandatory=$true)]
$VirtualNetworkSubnetName

)
#>

##################################################################################

##################################################################################
# Connect
##################################################################################
#Login-AzureRmAccount
#Save-AzureRmContext -Profile (Add-AzureRmAccount) -Path "c:\temp\azureprofile.json"
#Import-AzureRmContext -Path "c:\temp\azureprofile.json"

Import-AzureRmContext -Path "c:\temp\azureprofile.json"
#Login-AzureRmAccount
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionName "Provider Solutions Development"



$Location = "eastus2";


$ProjectName ="ad";

$ResourceGroupName ="rg-test-ad2";

$AdminUsername="abcadmin";

$AdminPassword="!Race2Win!"


$NumberOfInstances =1


$RegistrationKey ="";


$RegistrationUrl =""

$NodeConfigurationName =""


$TemplateFile=""


$VirtualNetworkResourceGroup="its-core-networking"

$VirtualNetworkSubnetName ="SSRS"

$virtualNetworkName ="its-core-vnet"

$WorkspaceId = "d15cc976-02c0-4c93-bbe6-95ecd5b0b308"

$WorkspaceKey = "Av7Ya4DMwf1A7tYZEBIYe2ns94jugHsFPYtrdWsi1e6Pz53z9azR5qiGxRKNq/8vMaVAssN71wyrH2GXIZZsvQ=="

$DomainToJoin = "abc.amerisourcebergen.com"

$DomainUsername = "abc\prd_sps_auto_job"

$DomainPassword = "KxE5y3odbN3Dd3*"

##################################################################################
# local Variables
##################################################################################

$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

##################################################################################
# Parameters
##################################################################################

 $Parameters = @{
     "adminUserName"="$AdminUsername";
     "adminPassword"=$AdminPassword;
    
     "projectName"=$ProjectName;
     "registrationKey"="$registrationKey";
     "registrationUrl"=$RegistrationUrl;
     "nodeConfigurationName"=$NodeConfigurationName;
     "timestamp"=$Timestamp;
    
     "numberOfInstances" = $NumberOfInstances;
     "virtualNetworkResourceGroup"=$VirtualNetworkResourceGroup;
     "virtualNetworkSubnetName" = $VirtualNetworkSubnetName;
     "virtualNetworkName" = $VirtualNetworkName;
     "workspaceId" = $WorkspaceId;
     "workspaceKey" = $WorkspaceKey;
     "domainToJoin" = $DomainToJoin;
     "domainUsername" = $DomainUsername;
     "domainPassword" = $DomainPassword;
 }

##################################################################################
# Create Resource group if needed
##################################################################################

$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
   New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

}
##################################################################################
# Deploy Template
##################################################################################

#New-AzureRmResourceGroupDeployment -ResourceGroupName  $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $Parameters
 
 $TemplateFile = "LoadBalancedVirtualMachine_SqlServer.json"

 New-AzureRmResourceGroupDeployment -ResourceGroupName  $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $Parameters
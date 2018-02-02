##################################################################################
# Instructions
##################################################################################
#Import module from marketplace in automation account : AzureRM.Profile, AzureRM.Network

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
$TemplateFile

)

##################################################################################
# Connect
##################################################################################
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint


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
     "vnetAddressPrefix"="$VnetAddressPrefix";
     "subnetAddressPrefix"=$SubnetAddressPrefix;
     "projectName"=$ProjectName;
     "registrationKey"="$registrationKey";
     "registrationUrl"=$RegistrationUrl;
     "nodeConfigurationName"=$NodeConfigurationName;
     "timestamp"=$Timestamp;
     "privateIpAddress" = $PrivateIPAddress;
     "numberOfInstances" = $NumberOfInstances;
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

New-AzureRmResourceGroupDeployment -ResourceGroupName  $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterObject $Parameters
 



param (

[Parameter(Mandatory=$true)]
$SubscriptionId,


[Parameter(Mandatory=$true)]
$DomainAdminUPN,

[Parameter(Mandatory=$true)]
$DomainJoinPassword





)

<#
Example Params:

$SubscriptionId = "4e883737-49fe-4ab1-b86d-548cf2411e95"

$DomainAdminUPN = "hersh@hershbymail.onmicrosoft.com"
$DomainJoinPassword = "x"
$ResourceGroup = "rg-images"
#>

########################################################
# Login
########################################################

$Secure_String_Pwd = ConvertTo-SecureString $DomainJoinPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($DomainAdminUPN, $Secure_String_Pwd)

Login-AzureRmAccount -Credential $cred -SubscriptionId  $SubscriptionId 
Connect-MsolService -Credential $cred




########################################################
#  Create AD Role
########################################################

$h = (Get-MsolGroup | where DisplayName -eq "EITS_Admins").objectid.guid

if ( $h -eq $null)
{
    New-MsolGroup -DisplayName "EITS_Admins" -Description "EITS Admins Group"
    Write-Output "admin ad group created"
}

  

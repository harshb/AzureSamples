
param (

[Parameter(Mandatory=$true)]
$SubscriptionId,


[Parameter(Mandatory=$true)]
$DomainAdminUPN,

[Parameter(Mandatory=$true)]
$DomainJoinPassword,


[Parameter(Mandatory=$true)]
$ResourceGroup,

[Parameter(Mandatory=$true)]
$ProjectName

)



<#
#Example Params:

$SubscriptionId = "4e883737-49fe-4ab1-b86d-548cf2411e95"

$DomainAdminUPN = "hersh@hershbymail.onmicrosoft.com"
$DomainJoinPassword = "xx"
$ResourceGroup = "rg-temp"
$ProjectName = "abc"
#>

########################################################
# vars
########################################################

$AdminGroup = "EITS_Admins"
$SQLServerName = $ProjectName + "sqlserver"

########################################################
# Login
########################################################

$Secure_String_Pwd = ConvertTo-SecureString $DomainJoinPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($DomainAdminUPN, $Secure_String_Pwd)

Login-AzureRmAccount -Credential $cred -SubscriptionId  $SubscriptionId 
#Connect-MsolService -Credential $cred

Connect-AzureAD -Credential $cred


########################################################
#  Assign Contriburer RBAC role to Resource Group
########################################################



$filter = "DisplayName eq '" + $AdminGroup + "'"

$h = get-azureadgroup -Filter  $filter | Select -ExpandProperty ObjectId

New-AzureRmRoleAssignment -ObjectId $h -RoleDefinitionName Contributor -ResourceGroupName $ResourceGroup


########################################################
#  Add Admin Group to  SQL Server
########################################################

Set-AzureRmSqlServerActiveDirectoryAdministrator –ResourceGroupName $ResourceGroup  –ServerName $SQLServerName -DisplayName  $AdminGroup
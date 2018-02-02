
param (

[Parameter(Mandatory=$true)]
$SubscriptionId,

[Parameter(Mandatory=$true)]
$TagAppTaxonomy,

[Parameter(Mandatory=$true)]
$TagEnvironmentType,

[Parameter(Mandatory=$true)]
$TagCostCenter,

[Parameter(Mandatory=$true)]
$TagExpirationDate,

[Parameter(Mandatory=$true)]
$TagProjectName,

[Parameter(Mandatory=$true)]
$DomainAdminUPN,

[Parameter(Mandatory=$true)]
$DomainJoinPassword




)

<#
Example Params:

$SubscriptionId = "4e883737-49fe-4ab1-b86d-548cf2411e95"
$TagAppTaxonomy = "EAP/Nova/NovaTestEnv1"
$TagEnvironmentType = "Dev"
$TagCostCenter = "F1230"
$TagExpirationDate = "2017-08-15T00:00"
$TagProjectName = "Nova Analytics Backend"
$DomainAdminUPN = "hersh@hershbymail.onmicrosoft.com"
$DomainJoinPassword = "xxx"
#>

########################################################
# Login
########################################################


$Secure_String_Pwd = ConvertTo-SecureString $DomainJoinPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($DomainAdminUPN, $Secure_String_Pwd)


Login-AzureRmAccount -Credential $cred -SubscriptionId  $SubscriptionId 



########################################################
#  Tags : AppTaxonomy
########################################################

$policyDefinitionName = "AppTaxonomy Tag"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = $policyDefinitionName

$definition = '
{
  "if": {
    "allof": [
      {
        "field": "tags",
        "exists": "true"
      },
      {
        "field": "tags.AppTaxonomy",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "append",
    "details": [
      {
        "field": "tags.AppTaxonomy",
        "value": "'+$TagAppTaxonomy+'"
      }
    ]
  }
}
'


$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId


########################################################
#  Tags : EnvironmentType
########################################################

$policyDefinitionName = "EnvironmentType Tag"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = $policyDefinitionName

$definition = '
{
  "if": {
    "allof": [
      {
        "field": "tags",
        "exists": "true"
      },
      {
        "field": "tags.EnvironmentType",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "append",
    "details": [
      {
        "field": "tags.EnvironmentType",
        "value": "'+$TagEnvironmentType+'"
      }
    ]
  }
}
'


$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId


#######################################################
#  Tags : CostCenter
########################################################

$policyDefinitionName = "CostCenter Tag"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = $policyDefinitionName

$definition = '
{
  "if": {
    "allof": [
      {
        "field": "tags",
        "exists": "true"
      },
      {
        "field": "tags.CostCenter",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "append",
    "details": [
      {
        "field": "tags.CostCenter",
        "value": "'+$TagCostCenter+'"
      }
    ]
  }
}
'


$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId

#######################################################
#  Tags : ExpirationDate
########################################################

$policyDefinitionName = "ExpirationDate Tag"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = $policyDefinitionName

$definition = '
{
  "if": {
    "allof": [
      {
        "field": "tags",
        "exists": "true"
      },
      {
        "field": "tags.ExpirationDate",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "append",
    "details": [
      {
        "field": "tags.ExpirationDate",
        "value": "'+$TagExpirationDate+'"
      }
    ]
  }
}
'


$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId

#######################################################
#  Tags : ExpirationDate
########################################################

$policyDefinitionName = "ProjectName Tag"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = $policyDefinitionName

$definition = '
{
  "if": {
    "allof": [
      {
        "field": "tags",
        "exists": "true"
      },
      {
        "field": "tags.ProjectName",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "append",
    "details": [
      {
        "field": "tags.ProjectName",
        "value": "'+$TagProjectName+'"
      }
    ]
  }
}
'


$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId

########################################################
#  Tags : If exist
########################################################



$policyDefinitionName = "RequiredTags"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = "RequiredTags"

$definition = '{
      "if": {
        "field": "tags",
        "exists": "false"
      },
      "then": 
      {
        "effect": "append",
        "details": 
            [
                {
                    "field": "tags",
                    "value": {"AppTaxonomy": "'+ $TagAppTaxonomy+ '"  , "EnvironmentType": "' +$TagEnvironmentType +'" , "CostCenter": "'+$TagCostCenter+'" , "ExpirationDate": "'+$TagExpirationDate+'" , "ProjectName": "'+$TagProjectName+'"}
                }
            
            ]
      }
    }'


$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId



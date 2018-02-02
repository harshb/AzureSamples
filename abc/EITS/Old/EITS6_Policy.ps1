
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
$DomainJoinPassword = "xxx"
#>

########################################################
# Login
########################################################


$Secure_String_Pwd = ConvertTo-SecureString $DomainJoinPassword -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($DomainAdminUPN, $Secure_String_Pwd)


Login-AzureRmAccount -Credential $cred -SubscriptionId  $SubscriptionId 





########################################################
#  Permitted OS
########################################################
$policyDefinitionName = "Permitted Operating System"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = "Policy to allow only Windows Server 2012 R2 Datacenter SUSE Linux Enterprise Server 12 SP2Virtual Machines to be created"

$definition = '
        {
          "if": {
            "allOf": [
              {
                "field": "type",
                "in": [
                  "Microsoft.Compute/disks",
                  "Microsoft.Compute/virtualMachines",
                  "Microsoft.Compute/VirtualMachineScaleSets"
                ]
              },
              {
                "not": {
                  "allOf": [
                    {
                      "field": "Microsoft.Compute/imagePublisher",
                      "in": [
                        "MicrosoftWindowsServer",
                        "SUSE"
                      ]
                    },
                    {
                      "field": "Microsoft.Compute/imageOffer",
                      "in": [
                        "WindowsServer",
                        "SLES"
                      ]
                    },
                    {
                      "field": "Microsoft.Compute/imageSku",
                      "in": [
                        "2012-R2-Datacenter",
                        "12-SP2"
                      ]
                    },
                    {
                      "field": "Microsoft.Compute/imageVersion",
                      "in": [
                        "latest"
                      ]
                    }
                  ]
                }
              }
            ]
          },
          "then": {
            "effect": "deny"
          }
        }

'

$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId


########################################################
# Deny peer to peer 
########################################################
$policyDefinitionName = "Disallow Peer to Peer"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = "Disallow Peer to Peer"

$definition = '{"if":{"anyOf":[{"source":"action","like":"Microsoft.Network/virtualNetworks/*"}]},"then":{"effect":"deny"}}'

$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId

########################################################
# Block public ip
########################################################
$policyDefinitionName = "Block Public IP"
$policyAssignmentName = $policyTagAssignmentName
$policyDescription = "Policy to Block Public IPs"

$definition = '{"if":{"anyOf":[{"source":"action","like":"Microsoft.Network/publicIPAddresses/*"}]},"then":{"effect":"deny"}}'

$policydef = New-AzureRmPolicyDefinition -Name $policyDefinitionName -Description $policyDescription -Policy $definition
 
# Assign the policy
New-AzureRmPolicyAssignment -Name $policyDefinitionName -PolicyDefinition $policydef -Scope  /subscriptions/$SubscriptionId
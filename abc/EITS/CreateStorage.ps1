#This script creates a storage account and uploads the ARM template

##################################################################################
# Login
##################################################################################
Login-AzureRmAccount




##################################################################################
# Params
##################################################################################

$ResourceGroupName = "its-dev-automation"

$Location = "eastus2"

$ProjectName = "infra"

##################################################################################
# variables
##################################################################################


$StorageAccountName =  $ProjectName + "automationstorage" 
 
$StorageContainername = $StorageAccountName + "container"



##################################################################################
# Create Resource group if needed
##################################################################################

$resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
   New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

}

##################################################################################
# Storage
##################################################################################

$StorageAccount = @{
    ResourceGroupName = $ResourceGroupName;
    Name = $StorageAccountName;
    SkuName = 'Standard_LRS';
    Location =  $Location;
    }
New-AzureRmStorageAccount @StorageAccount;


### Obtain the Storage Account authentication keys using Azure Resource Manager (ARM)
$Keys = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name  $StorageAccountName;

### Use the Azure.Storage module to create a Storage Authentication Context
$StorageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $Keys[0].Value;


### Create a storage Blob Container in the Storage Account
New-AzureStorageContainer -Context $StorageContext -Name $StorageContainername  -Permission Container;


##################################################################################
# Upload the template file
##################################################################################

### Upload a file to the Microsoft Azure Storage Blob Container
$UploadFile = @{
    Context = $StorageContext;
    Container = $StorageContainername ;
    File = ".\LoadBalancedVirtualMachine.json";
    }
Set-AzureStorageBlobContent @UploadFile;


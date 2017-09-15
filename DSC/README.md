# Introduction 


# 1. Automation Account Set Up

1. Create an Automation Account

2. Install Modules from the Modules Gallery of the automation account. These modules are required for adding network rules to the VM. 

   ​	a) AzureRM.Profile  

   ​	b) AzureRM.Network



# 2. Create a Storage For Template File

Run the deployment\CreateStorage.ps1 file  in the project. 

**It expects Parameters**

1. ResourceGroup : The resource group the automation account was created under (Step1)
2. Location: 

**This will**:

1. Creates a blog storage account, 
2. create a container
3. Give appropriate access level
4. upload the ARM template "vmautomation_dsc.json" to the blob storage. This is the ARM template for creating the VM + associated resources. It also has the DSC extension & will register the VM as a node in the DSC server, when run later by the Run Book "DeployVm"

Enter the  path of the template file in automation variable:  TemplateFileUrl  (Section 4)

**Make note of the path of the  template file**

You will need to provide the path of the template file as a parameter when running Run Book DeployVM (Step 6). Path will be something like: https://dccteststorage.blob.core.windows.net/abcarmtemplate/vmautomation_dsc.json

# 3. Create File Storage For Installer Files

In the storage account created in Step 2, create a file storage account with the following directory structure:

absg

​	packages

​		CA 

​		FireEye (3 files)

​		ILMT (16 files)

​			Profiles 



Download installer files from : http://abceitspackagessa.blob.core.windows.net/packagecontainer/ABSG%20agent%20installers.zip

Upload all installers to appropriate directories

1. ca: upload files from \Current manual install(ABC Domain)\temp : 4 files
2. FireEye : from root of install folder:  3 files
3. ILMT:  from profile of install folder to profile folder of file share (16 files), from root to root (1 file). 

**Make note of the Key & Storage Name**

Note down the Key & Storage Name. You will need it when creating the Credential Asset in the Automation Account (Step 4).

# 4. Update Automation Account 

## Create a  Credential Assert

In Section 3, you created a file storage to hold the installer files. In the automation account, you create a credential asset to point to that file storage

**Name**: DSCPackageStorage

Username: AZURE\file-storage-name (this is the name of the storage account, prefixed by "AZURE\")

Password: Key of the file storage 

#5. DSC Configuration File

1. From this git project, import the file called DefaultServerConfig.ps1 to the **DSC  Configurations** section in your-automation-account
2.  When Imported, Click on it, compile it by choosing Compile on the Toolbar. Let it default for the ComputerName ("Default will be used").
3. The screen does not automatically refresh. 
4. After it is published,  click on the link "DSC node configurations, "note  the resultant name  of the configuration (DefaultServerConfig.localhost) . You will need to pass this as a parameter to the Runbook  DeployVM 


# 6. Import Run Books in Automation Account

1. RunDeploy.ps1 : a helper file to pass in the parameters to DeployVm.ps1

2. DeployVm.ps1: the main file that creates the VM by calling the ARM template

3. RunNsg.ps1: called by DeployVm, responsible for creating Network Security Group/ Rules for the VM.

   There a number of variables passed in but the important ones are

   ```json
   $RegistrationKey : Key of the DSC automation account (found on the Keys section of the automation account)

   $RegistrationUrl: URL of the automation account, found also in the Keys section of the automation account

   $NodeConfigurationName:  The name of the configuration noted in Step 5.$TemplateFile: The full path to the arm template noted in Step 2.

   ```

4. Publish the run books

# 7. Running

Run the Runbook : RunDeploy.ps1.  Once the VM is provisioned, you should see it appear under the DSC nodes section of the automation account and reported as "Compliant"
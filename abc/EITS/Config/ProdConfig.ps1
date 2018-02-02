Configuration DevConfig
{
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
   $storageCredential = Get-AutomationPSCredential -Name "DSCPackageStorage"
   $sourcePath = Get-AutomationVariable –Name 'DownloadPackagesPath'

    Node "localhost"
    {
       
        File DirectoryCopy
        {
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Type = "Directory" # Default is "File".
            Checksum = "ModifiedDate"
            MatchSource = $true
            Force = $true
            Recurse = $true # Ensure presence of subdirectories, too
            Credential = $storageCredential
            SourcePath = $sourcePath
            DestinationPath = "C:\ccmsetup"    
        }
        Log AfterDirectoryCopy
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID DirectoryCopy"
            DependsOn = "[File]DirectoryCopy" # This means run "DirectoryCopy" first.
        }

        Script Install_Ccmsetup
        {
            
            GetScript = {@{Result = "Install_Ccmsetup"}}
                    
            TestScript = { 
                
              
               Test-Path "C:\Windows\ccmsetup\CCMSetup.exe"
            }
            SetScript = { 

                $proc = Start-Process -FilePath "C:\ccmsetup\CCMSetup.exe" -ArgumentList "/mp:SVRSCCM4T001.NPD.amerisourcebergen.com SMSSITECODE=NPD FSP=SVRSCCM4T001 SMSSLP=SVRSCCM4T001 dnssuffix=npd.amerisourcebergen.com resetkeyinformation=true" -PassThru -Wait
                
                Switch($proc.ExitCode)
                {
                  0 {
                    # Success
                  }
                  1603 {
                    Throw "Failed installation"
                  }
                  1641 {
                    # Restart required
                    $global:DSCMachineStatus = 1                
                  }
                  3010 {
                    # Restart required
                    $global:DSCMachineStatus = 1                
                  }
                  5100 {
                    Throw "Computer does not meet system requirements."
                  }
                  default {
                    Throw "Unknown exit code $($proc.ExitCode)"
                  }
                }
               
            }

            DependsOn = "[File]DirectoryCopy"
        }

       
      
    }
}
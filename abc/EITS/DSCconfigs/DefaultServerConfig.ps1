Configuration DefaultServerConfig
{

    $storageCredential = Get-AutomationPSCredential -Name "DSCPackageStorage"
    $sourcePath = Get-AutomationVariable -Name "DownloadPackagePath"

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
            DestinationPath = "C:\Packages"    
        }

        Log AfterDirectoryCopy
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID DirectoryCopy"
            DependsOn = "[File]DirectoryCopy" # This means run "DirectoryCopy" first.
        }

   
        Package Install_FireEye
        {
            Ensure = "Present"
            Name = "xagt"
            DependsOn = "[File]DirectoryCopy"
            Path = "C:\Packages\FireEye\xagtSetup_21.33.7_universal.msi"
            Arguments = "/q"
            ProductId = "55E1EF02-DA68-46D3-8659-6A29822F65C1"
        }

        Log AfterInstall_FireEye
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID Install_FireEye"
            DependsOn = "[Package]Install_FireEye" # This means run "Install_FireEye" first.
        }
        
        Package Install_McAfee
        {
            Ensure = "Present"
            Name = "McAfee"
            DependsOn = "[File]DirectoryCopy"
            Path = "C:\Packages\McAfee\FramePkg.exe"
            Arguments = "/INSTALL=AGENT /SILENT"
            ProductId = "EBF3D65F-011E-44D2-8F4F-C74B52682EDD"
        }

        Log AfterInstall_McAfee
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID Install_McAfee"
            DependsOn = "[Package]Install_McAfee" # This means run "Install_McAfee" first.
        }
        
        Package Install_ILMT
        {
            Ensure = "Present"
            Name = "ILMT-TAD4D Agent"
            DependsOn = "[File]DirectoryCopy"
            Path = "C:\Packages\ILMT\setup.exe"
            Arguments = '/z"/sfc:\Packages\ILMT\response_file.txt /noprecheck" /L1033 /s /f2"c:\windows\temp\ILMT.log"'
            ProductId = "C18D2775-33F4-4CE9-B071-4ECC78DA5E33"
        }

        Log AfterInstall_ILMT
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the file resource with ID Install_ILMT"
            DependsOn = "[Package]Install_ILMT" # This means run "Install_ILMT" first.
        }
        
        Registry DisableIPv6
        {
            Ensure      = "Present"  # You can also set Ensure to "Absent"
            Key         = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\"
            ValueName   = "DisabledComponents"
            ValueType = "Dword"
            Hex = $true
            ValueData   = "0x11"
            Force = $true
        }

   

    }
}
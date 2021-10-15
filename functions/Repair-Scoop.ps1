function Repair-Scoop {
    [CmdletBinding()]
    param (
        [Parameter(
            Position=1,
            Mandatory=$false,
            HelpMessage="Include apps that are installed as current user")]
        [switch]
        $UserApps = $false,

        [Parameter(
            Position=1,
            Mandatory=$false,
            HelpMessage="Include apps that are installed globaly")]
        [switch]
        $GlobalApps = $false
    )
    
    begin {
        $userAppsPath = "$env:UserProfile\scoop\apps"
        $globalAppsPath = "C:\ProgramData\scoop\apps"
    }
    
    process {
        if ($UserApps -eq $true){
            foreach ($folder in (Get-ChildItem -Path $userAppsPath)){
                $manifestPath = $folder.ToString() + "\current\scoop-manifest.json"
                if (!(Test-Path -Path $manifestPath)){
                    Reset-Scoop -App $folder.Name
                }
            }
        }
        if ($GlobalApps -eq $true){
            foreach ($folder in (Get-ChildItem -Path $globalAppsPath)){
                $manifestPath = $folder.ToString() + "\current\scoop-manifest.json"
                if (!(Test-Path -Path $manifestPath)){
                    Reset-Scoop -App $folder.Name
                }
            }
        }
    }
    
    end {
        
    }
}
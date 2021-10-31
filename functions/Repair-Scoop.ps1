function Repair-Scoop {
    [CmdletBinding()]
    param (
        [Alias("ua")]
        [Parameter(
            Position=1,
            Mandatory=$false,
            HelpMessage="Include apps that are installed as current user")]
        [switch]
        $UserApps = $false,

        [Alias("ga")]
        [Parameter(
            Position=2,
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
                $manifestPath = $folder.FullName + "\current\scoop-manifest.json"
                if ((Test-Path -Path $manifestPath) -eq $false){
                    Reset-Scoop -App $folder.Name
                }
            }
        }
        if ($GlobalApps -eq $true){
            foreach ($folder in (Get-ChildItem -Path $globalAppsPath)){
                $manifestPath = $folder.FullName + "\current\scoop-manifest.json"
                if ((Test-Path -Path $manifestPath) -eq $false){
                    Reset-Scoop -App $folder.Name
                }
            }
        }
    }
    
    end {
        
    }
}
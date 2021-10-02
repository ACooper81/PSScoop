<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

function Update-Scoop {
    [CmdletBinding()]
    param (
        [Parameter(
            Position=1,
            Mandatory=$false,
            HelpMessage="Update app using id")]
        [string]
        $App = "",

        [Parameter(
            Position=2,
            Mandatory=$false,
            HelpMessage="Update a list of apps using id")]
        [string[]]
        $Apps,

        [Parameter(
            Position=3,
            Mandatory=$false,
            HelpMessage="Update all installed apps")]
        [switch]
        $AllApps = $false,

        [Parameter(
            Position=4,
            Mandatory=$false,
            HelpMessage="Update only user apps")]
        [switch]
        $UserApps = $false,

        [Parameter(
            Position=5,
            Mandatory=$false,
            HelpMessage="Update only global apps")]
        [switch]
        $GlobalApps = $false,

        [Parameter(
            Position=6,
            Mandatory=$false,
            HelpMessage="Update scoop and buckets.")]
        [switch]
        $Buckets = $false,

        [Parameter(
            Position=7,
            Mandatory=$false,
            HelpMessage="Performs action on global apps")]
        [switch]
        $Global = $false,

        [Parameter(
            Position=8,
            Mandatory=$false,
            HelpMessage="Forces action")]
        [switch]
        $Force = $false,

        [Parameter(
            Position=9,
            Mandatory=$false,
            HelpMessage="Do not download files to cache folder")]
        [switch]
        $NoCache = $false
    )
    
    begin {
        $userAppsList = @{}
        $globalAppsList = @{}
        $userAppsList = Get-ScoopApps -User
        $globalAppsList = Get-ScoopApps -Global
    }
    
    process {
        if ($Buckets -eq $true){
            Invoke-Command {& scoop update}
        }
        if ($App -ne ""){
            $commandString = ""
            $globalString = ""
            $forceString = ""
            $noCacheString = ""
            $commandString = "& scoop update $App"
            if ($Global -eq $true){$globalString = "-g"}
            if ($Force -eq $true){$forceString = "-f"}
            if ($NoCache -eq $true){$noCacheString = "-k"}
            $command = "$commandString $globalString $forceString $noCacheString"
            # Write-Verbose -Message $command
            Invoke-Expression $command
        }
        if ($Apps -ne ""){
            # $userApps = Get-ScoopApps -User
            # $globalApps = Get-ScoopApps -Global
            foreach ($item in $Apps) {
                if ($userAppsList.Contains($item)){
                    Update-Scoop -App $item
                }
                if ($globalAppsList.Contains($item) -and $Global -eq $true){
                    Update-Scoop -App $item -Global
                }
            }
        }
        if($AllApps -eq $true){
            foreach ($item in $userAppsList.Keys) {
                Update-Scoop -App $item
            }
            foreach ($item in $globalAppsList.Keys) {
                Update-Scoop -App $item -Global
            }
        }
        if($GlobalApps -eq $true){
            foreach ($item in $globalAppsList.Keys) {
                Update-Scoop -App $item -Global
            }
        }
        if($UserApps -eq $true){
            foreach ($item in $userAppsList.Keys) {
                Update-Scoop -App $item
            }
        }
    }
    
    end {
        
    }
}
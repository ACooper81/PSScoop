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
        $userAppsList = Get-Scoop -UserApps
        $globalAppsList = Get-Scoop -GlobalApps
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
            Invoke-Expression $command
        }
        if ($Apps -ne ""){
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
            $userAppUpdates = @{}
            foreach ($item in $userAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $userAppsList[$item].bucket
                if ($obj[$item].version -ne $userAppsList[$item].version) {
                    $userAppUpdates.Add($obj[$item].id, $obj)
                    $output = $obj[$item].id + ": " + $userAppsList[$item].version + " -> " + $obj[$item].version + " (User)"
                    Write-Output $output
                }
            }
            $globalAppUpdates = @{}
            foreach ($item in $globalAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $globalAppsList[$item].bucket
                if ($obj[$item].version -gt $globalAppsList[$item].version) {
                    $globalAppUpdates.Add($obj[$item].id, $obj)
                    $output = $obj[$item].id + ": " + $globalAppsList[$item].version + " -> " + $obj[$item].version + " (Global)"
                    Write-Output $output
                }
            }
            foreach ($update in $userAppUpdates.Keys){
                Update-Scoop -App $update
            }
            foreach ($update in $globalAppUpdates.Keys){
                Update-Scoop -App $update -Global
            }
        }
        if($UserApps -eq $true){
            $userAppUpdates = @{}
            foreach ($item in $userAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $userAppsList[$item].bucket
                if ($obj[$item].version -ne $userAppsList[$item].version) {
                    $userAppUpdates.Add($obj[$item].id, $obj)
                    $output = $obj[$item].id + ": " + $userAppsList[$item].version + " -> " + $obj[$item].version + " (User)"
                    Write-Output $output
                }
            }
            foreach ($update in $userAppUpdates.Keys){
                Update-Scoop -App $update
            }
        }
        if($GlobalApps -eq $true){
            $globalAppUpdates = @{}
            foreach ($item in $globalAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $globalAppsList[$item].bucket
                if ($obj[$item].version -gt $globalAppsList[$item].version) {
                    $globalAppUpdates.Add($obj[$item].id, $obj)
                    $output = $obj[$item].id + ": " + $globalAppsList[$item].version + " -> " + $obj[$item].version + " (Global)"
                    Write-Output $output
                }
            }
            foreach ($update in $globalAppUpdates.Keys){
                Update-Scoop -App $update -Global
            }
        }
    }
    
    end {
        
    }
}
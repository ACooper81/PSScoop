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
            Position=0,
            Mandatory=$false,
            HelpMessage="Update scoop and buckets.")]
        [switch]
        $Buckets = $false,

        [Parameter(
            Position=1,
            Mandatory=$false,
            HelpMessage="Update app using id")]
        [string]
        $App,

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
        $AllApps,

        [Parameter(
            Position=4,
            Mandatory=$false,
            HelpMessage="Perform action on global apps")]
        [switch]
        $Global
    )
    
    begin {
        $userApps = @{}
        $globalApps = @{}
        $userApps = Get-ScoopApps -User
        $globalApps = Get-ScoopApps -Global
    }
    
    process {
        if ($Buckets -eq $true){
            Invoke-Command {& scoop update}
        }
        if ($App -ne $null -and $App -ne ""){
            if ($userApps.Contains($App)){
                Invoke-Command {& scoop update $App}
            }
            if ($globalApps.Contains($App) -and $Global -eq $true){
                Invoke-Command {& scoop update $App -g}
            }
        }
        if ($Apps -ne ""){
            # $userApps = Get-ScoopApps -User
            # $globalApps = Get-ScoopApps -Global
            foreach ($item in $Apps) {
                if ($userApps.Contains($item)){
                    Invoke-Command {& scoop update $item}
                }
                if ($globalApps.Contains($item) -and $Global -eq $true){
                    Invoke-Command {& scoop update $item -g}
                }
            }
        }
        if($AllApps -eq $true){
            foreach ($item in $userApps.Keys) {
                Update-Scoop -App $item
            }
            foreach ($item in $globalApps.Keys) {
                if ($Global -eq $true){
                    Update-Scoop -App $item -Global
                }
            }
        }
    }
    
    end {
        
    }
}
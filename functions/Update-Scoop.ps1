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
        [Alias("a")]
        [Parameter(
            Position=1,
            Mandatory=$false,
            HelpMessage="Update app using id")]
        [string[]]
        $App = "",

        [Parameter(
            Position=2,
            Mandatory=$false,
            HelpMessage="Update a list of apps using id")]
        [string[]]
        $Apps,

        [Alias("aa")]
        [Parameter(
            Position=3,
            Mandatory=$false,
            HelpMessage="Update all installed apps")]
        [switch]
        $AllApps = $false,

        [Alias("ua")]
        [Parameter(
            Position=4,
            Mandatory=$false,
            HelpMessage="Update only user apps")]
        [switch]
        $UserApps = $false,

        [Alias("ga")]
        [Parameter(
            Position=5,
            Mandatory=$false,
            HelpMessage="Update only global apps")]
        [switch]
        $GlobalApps = $false,

        [Alias("b")]
        [Parameter(
            Position=6,
            Mandatory=$false,
            HelpMessage="Update scoop and buckets.")]
        [switch]
        $Buckets = $false,

        [Alias("g")]
        [Parameter(
            Position=7,
            Mandatory=$false,
            HelpMessage="Performs action on global apps")]
        [switch]
        $Global = $false,

        [Alias("f")]
        [Parameter(
            Position=8,
            Mandatory=$false,
            HelpMessage="Forces action")]
        [switch]
        $Force = $false,

        [Alias("k")]
        [Parameter(
            Position=9,
            Mandatory=$false,
            HelpMessage="Do not download files to cache folder")]
        [switch]
        $NoCache = $false,

        [Alias("r")]
        [Parameter(
            Position=9,
            Mandatory=$false,
            HelpMessage="Resets and reinstalls broken apps")]
        [switch]
        $Repair = $false
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
        if ($App -ne $null){
            # foreach ($item in $App){
            #     if ($userAppsList.Contains($item)){
            #         $commandString = ""
            #         $globalString = ""
            #         $forceString = ""
            #         $noCacheString = ""
            #         $commandString = "& scoop update $item"
            #         if ($Force -eq $true){$forceString = "-f"}
            #         if ($NoCache -eq $true){$noCacheString = "-k"}
            #         $command = "$commandString $globalString $forceString $noCacheString"
            #         Invoke-Expression $command
            #     }
            #     if (($globalAppsList.Contains($item) -and $Global -eq $true) -or ($globalAppsList.Contains($item) -and $GlobalApps -eq $true) -or ($globalAppsList.Contains($item) -and $AllApps -eq $true)){
            #         $commandString = ""
            #         $globalString = ""
            #         $forceString = ""
            #         $noCacheString = ""
            #         $commandString = "& scoop update $item"
            #         if ($Global -eq $true){$globalString = "-g"}
            #         if ($Force -eq $true){$forceString = "-f"}
            #         if ($NoCache -eq $true){$noCacheString = "-k"}
            #         $command = "$commandString $globalString $forceString $noCacheString"
            #         Invoke-Expression $command
            #     }
            # }
            if ($App.Length -gt 1){
                $Apps = $App
            }else{
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
            if ($Repair -eq $true){
                Repair-Scoop -UserApps
            }
            foreach ($item in $userAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $userAppsList[$item].bucket
                if ($null -eq $obj){
                    $errorMsg = $userAppsList[$item].id + " has been removed from " + $userAppsList[$item].bucket
                    Write-Output $errorMsg
                }
                if ($null -eq $globalAppsList[$item] -or $null -eq $obj[$item]){
                    Write-Output "$item not found in bucket."
                }
                elseif ($null -ne $obj -and $obj[$item].version -ne $userAppsList[$item].version) {
                    $userAppUpdates.Add($obj[$item].id, $obj)
                    $output = $obj[$item].id + ": " + $userAppsList[$item].version + " -> " + $obj[$item].version + " (User)"
                    Write-Output $output
                }
            }
            $globalAppUpdates = @{}
            if ($Repair -eq $true){
                Repair-Scoop -GlobalApps
            }
            # Write-Verbose $globalAppsList.Keys
            foreach ($item in $globalAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $globalAppsList[$item].bucket
                # Write-Verbose $obj.Keys
                if ($null -eq $obj){
                    $errorMsg = $globalAppsList[$item].id + " has been removed from " + $globalAppsList[$item].bucket
                    Write-Output $errorMsg
                }
                # $versionCheck = $obj[$item].id + $obj[$item].version + "->" + $globalAppsList[$item].version
                # Write-Verbose (($obj[$item].version) -gt ($globalAppsList[$item].version))
                if ($null -eq $globalAppsList[$item] -or $null -eq $obj[$item]){
                    Write-Output "$item not found in bucket."
                }
                elseif ($null -ne $obj -and $obj[$item].version -ne $globalAppsList[$item].version) {
                    # Write-Verbose $obj[$item].id
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
                Write-Verbose $update
            }
        }
        if($UserApps -eq $true){
            $userAppUpdates = @{}
            if ($Repair -eq $true){
                Repair-Scoop -UserApps
            }
            foreach ($item in $userAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $userAppsList[$item].bucket
                if ($null -ne $obj -and $obj[$item].version -ne $userAppsList[$item].version) {
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
            if ($Repair -eq $true){
                Repair-Scoop -GlobalApps
            }
            foreach ($item in $globalAppsList.Keys) {
                $obj = Get-Scoop -App $item -Bucket $globalAppsList[$item].bucket
                if ($null -ne $obj -and $obj[$item].version -ne $globalAppsList[$item].version) {
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
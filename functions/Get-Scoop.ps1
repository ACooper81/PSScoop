<#
.SYNOPSIS
    Get the currently install scoop packages
.DESCRIPTION
    Get the current installed packages using the scoop package manager https://scoop.sh
.EXAMPLE
    PS C:\> Get-Scoop
    This example will return the currently install scoop packages.
.INPUTS
    Optional String $Filter
.OUTPUTS
    System.String
.NOTES
    
#>
function Get-Scoop {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            Mandatory = $false,
            HelpMessage = "Include apps that are installed globaly"
        )]
        [Switch]
        $GlobalApps = $false,

        [Parameter(
            Position = 2,
            Mandatory = $false,
            HelpMessage = "Include apps that are installed as current user"
        )]
        [Switch]
        $UserApps = $false,

        [Parameter(
            Position = 3,
            Mandatory = $false,
            HelpMessage = "Get app manifest"
        )]
        [String]
        $App = "",

        [Parameter(
            Position = 3,
            Mandatory = $false,
            HelpMessage = "Get app manifest from this bucket"
        )]
        [String]
        $Bucket = ""
    )
    
    begin {
        # $objs = $null
        # $objs = '{"key": "value"}' | ConvertFrom-Json -AsHashtable
        $objs = [ordered]@{}
        # Write-Verbose $objs.Keys
        # $objs.Clear()

        # $obj.GetEnumerator() | ForEach-Object{if($_.key -like "*Install*"){Write-Output $_.key; Write-Output $_.Value}}
        $bucketsPath = "$env:UserProfile\scoop\buckets"
        $userAppsPath = "$env:UserProfile\scoop\apps"
        $globalAppsPath = "C:\ProgramData\scoop\apps"
    }
    
    process {
        if ($App -ne "" -and $Bucket -ne ""){
            $manifestPath = Get-ChildItem -Path "$bucketsPath\$Bucket\" -Filter "$App.json" -Recurse -ErrorAction SilentlyContinue -Force
            if ($null -ne $manifestPath -and (Test-Path -Path $manifestPath)){
                $obj = New-ScoopManifestObject -Path $manifestPath
                $currentId = $obj.id
                $objs.Add($currentId, $obj)
            }

        }
        # if ($GlobalApps -eq $false -and $UserApps -eq $false){
        #     # Write-Verbose "Both false"
        #     $GlobalApps = $true
        #     $UserApps = $true
        # }
        if ($UserApps -eq $true){
            # Write-Verbose "User true"
            # Write-Verbose Get-ChildItem -Path $userAppsPath
            # (Get-ChildItem -Path $userAppsPath) | Sort-Object -Property key | ForEach-Object {
            foreach ($folder in (Get-ChildItem -Path $userAppsPath)){
                # Write-Verbose Get-ChildItem -Path $userAppsPath
                # Write-Verbose $folder
                $obj = @{}
                $manifestPath = $folder.FullName + "\current\scoop-manifest.json"
                # Write-Verbose $manifestPath
                if (Test-Path -Path $manifestPath){
                    $obj = New-ScoopManifestObject -Path $manifestPath
                    $currentId = $obj.id
                    # Write-Verbose $obj
                    # Write-Verbose $currentId
                    $objs.Add($currentId, $obj)
                    # $objs.$currentId = $obj
                }
            }
        }
        if ($GlobalApps -eq $true){
            # Write-Verbose "Global true"
            # (Get-ChildItem -Path $globalAppsPath) | Sort-Object -Property key | ForEach-Object {
            foreach ($folder in (Get-ChildItem -Path $globalAppsPath)){
                $obj = @{}
                $manifestPath = $folder.FullName + "\current\scoop-manifest.json"
                if (Test-Path -Path $manifestPath){
                    $obj = New-ScoopManifestObject -Path $manifestPath
                    $currentId = $obj.id
                    # Write-Verbose $currentId
                    if ($objs.Contains($currentId)){
                        Write-Verbose "$currentId is installed in the user profile."
                    }
                    else{
                        $objs.Add($currentId, $obj)
                        # $objs.$currentId = $obj
                    }
                }
            }
        }
    }
    
    end {
        # $objs = $objs.GetEnumerator() | Sort-Object -Property name
        # Write-Output ($objs.GetEnumerator() | Sort-Object -Property Name)
        return $objs
    }
}#Get-ScoopPackages
<#
.SYNOPSIS
    Get the currently install scoop packages
.DESCRIPTION
    Get the current installed packages using the scoop package manager https://scoop.sh
.EXAMPLE
    PS C:\> Get-ScoopPackage
    This example will return the currently install scoop packages.
.EXAMPLE
    PS C:\> Get-ScoopPackage "Install"
    This example will return the currently install scoop packages with Install in the name.
.INPUTS
    Optional String $Filter
.OUTPUTS
    System.String
.NOTES
    
#>
function Get-ScoopApps {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            Mandatory = $false,
            HelpMessage = "Include packages that are installed Globaly"
        )]
        [Switch]
        $Global = $false,

        [Parameter(
            Position = 2,
            Mandatory = $false,
            HelpMessage = "Include packages that are installed as current user"
        )]
        [Switch]
        $User = $false
    )
    
    begin {
        # $objs = $null
        # $objs = '{"key": "value"}' | ConvertFrom-Json -AsHashtable
        $objs = @{}
        # Write-Verbose $objs.Keys
        $objs.Clear()
        
        # $obj.GetEnumerator() | ForEach-Object{if($_.key -like "*Install*"){Write-Output $_.key; Write-Output $_.Value}}
        $userPath = "C:\Users\Adrian\scoop\apps"
        # Write-Verbose $userPath
        $globalPath = "C:\ProgramData\scoop\apps"
        # Write-Verbose $globalPath
    }
    
    process {
        if ($Global -eq $false -and $User -eq $false){
            # Write-Verbose "Both false"
            $Global = $true
            $User = $true
        }
        if ($User -eq $true){
            # Write-Verbose "User true"
            foreach ($folder in (Get-ChildItem -Path $userPath)){
                # Write-Verbose $folder
                $obj = @{}
                $manifestPath = $folder.ToString() + "\current\scoop-manifest.json"
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
        if ($Global -eq $true){
            # Write-Verbose "Global true"
            foreach ($folder in (Get-ChildItem -Path $globalPath)){
                $obj = @{}
                $manifestPath = $folder.ToString() + "\current\scoop-manifest.json"
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
        # Write-Verbose "This function has run"
    }
    
    end {
        $objs = $objs.GetEnumerator() | Sort-Object Name
        return $objs
    }
}#Get-ScoopPackages
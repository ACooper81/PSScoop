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
function Get-ScoopPackages {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            Mandatory = $false,
            HelpMessage = "Include packages that are installed Globaly"
        )]
        [Switch]
        $Global,

        [Parameter(
            Position = 2,
            Mandatory = $false,
            HelpMessage = "Include packages that are installed as current user"
        )]
        [Switch]
        $User
    )
    
    begin {
        $objs = @{}
        $userPath = "C:\Users\Adrian\scoop\apps"
        $globalPath = "C:\ProgramData\scoop\apps"
    }
    
    process {
        if ($Global -eq $false -and $User -eq $false){
            $Global = $true
            $User = $true
        }
        if ($Global -eq $true){
            foreach ($folder in (Get-ChildItem -Path $globalPath)){
                $obj = @{}
                $manifestPath = $folder.ToString() + "\\current\\scoop-manifest.json"
                if (Test-Path -Path $manifestPath){
                    $obj = New-ScoopManifestObject -Path $manifestPath
                    $objs.Add(($obj.id), $obj)
                }
            }
        }
        if ($User -eq $true){
            foreach ($folder in (Get-ChildItem -Path $userPath)){
                $obj = @{}
                $manifestPath = $folder.ToString() + "\\current\\scoop-manifest.json"
                if (Test-Path -Path $manifestPath){
                    $obj = New-ScoopManifestObject -Path $manifestPath
                    if ($objs.Contains($obj.id)){
                        $currentId = $obj.id
                        Write-Verbose "$currentId is already installed globally"
                    }
                    else{
                        $objs.Add(($obj.id), $obj)
                    }
                }
            }
        }

        
    }
    
    end {
        return $objs
    }
}#Get-ScoopPackages
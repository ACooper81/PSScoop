<#
.SYNOPSIS
    Get the currently install scoop packages
.DESCRIPTION
    Get the current installed packages using the scoop package manager https://scoop.sh
.EXAMPLE
    PS C:\> Get-ScoopPackage
    This example will return the currently install scoop packages.

    PS C:\> Get-ScoopPackage "Install"
    This example will return the currently install scoop packages with Install in the name.
.INPUTS
    Optional String $searchstring
.OUTPUTS
    System.String
.NOTES
    
#>
function Get-ScoopPackages {
    [CmdletBinding()]
    param (
        [string]$searchstring = ''
    )
    
    begin {
        
    }
    
    process {
        $result = (powershell scoop list $searchstring) | Out-String
    }
    
    end {
        return $result
    }
}
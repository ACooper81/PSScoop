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
        # Filter the currently installed packages by manifest ID
        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [String]
        $Filter,

        # Return packages that are installed globaly
        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [Switch]
        $Global = $false
    )
    
    begin {
        
    }
    
    process {
        $result = (powershell scoop list $Filter) | Out-String
    }
    
    end {
        return $result
    }
}
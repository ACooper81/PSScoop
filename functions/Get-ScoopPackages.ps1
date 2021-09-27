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
            Position = 0,
            Mandatory = $false,
            HelpMessage = "Filter the currently installed packages by manifest ID"
        )]
        [String]
        $Filter,

        [Parameter(
            Position = 1,
            HelpMessage = "Return packages that are installed globaly"
        )]
        [Switch]
        $Global
    )
    
    begin {
        
    }
    
    process {
        $result = (powershell scoop list $Filter) | Out-String
    }
    
    end {
        return $result
    }
}#Get-ScoopPackages
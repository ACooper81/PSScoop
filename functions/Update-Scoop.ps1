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
        # Updates scoop app and installed buckets
        [Parameter(
            Mandatory=$false,
            Position=0,
            HelpMessage="Update scoop and buckets.")]
        [switch]
        $Buckets
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}
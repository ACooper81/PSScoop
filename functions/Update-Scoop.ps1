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
        $App
    )
    
    begin {
        
    }
    
    process {
        if ($buckets -eq $true){
            
        }
        if ($App -ne $null -and $App -ne ""){
            # $userApps = Get-ScoopApps -User
            # $globalApps = Get-ScoopApps -Global
            Invoke-Command {& scoop update $App}
            Invoke-Command {& scoop update $App -g}
        }
    }
    
    end {
        
    }
}
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

function New-ScoopManifestObject {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "Manifest ID"
        )]
        [String]
        $ID,

        [Parameter(
            Position = 1,
            Mandatory = $true,
            HelpMessage = "Manifest Bucket"
        )]
        [String]
        $Bucket,

        [Parameter(
            Position = 2,
            Mandatory = $false,
            HelpMessage = "Manifest Scope"
        )]
        [String]
        $Scope = "User",

        [Parameter(
            Position = 3,
            Mandatory = $false,
            HelpMessage = "Manifest Version"
        )]
        [String]
        $Version = ""
    )
    
    $obj = [PSCustomObject]@{
        ID = $ID
        Bucket = $Bucket
        Scope = $Scope
        Version = $Version
        Name = $Name
        Description = $Description
        Website = $Website
        License = $License
        Path = $Path
        Binaries = $Binaries
    }

    $obj | Add-Member -MemberType ScriptMethod -Name Update -Value {& scoop update $obj.ID}

    return $obj
}
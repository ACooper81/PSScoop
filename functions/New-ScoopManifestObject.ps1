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
            Mandatory = $true,
            HelpMessage = "Manifest Version"
        )]
        [String]
        $Version,

        [Parameter(
            Position = 3,
            Mandatory = $false,
            HelpMessage = "Manifest Name"
        )]
        [String]
        $Name,

        [Parameter(
            Position = 4,
            Mandatory = $false,
            HelpMessage = "Manifest Description"
        )]
        [String]
        $Description,

        [Parameter(
            Position = 5,
            Mandatory = $false,
            HelpMessage = "Manifest Website"
        )]
        [String]
        $Website,

        [Parameter(
            Position = 6,
            Mandatory = $false,
            HelpMessage = "Manifest License"
        )]
        [String]
        $License,

        [Parameter(
            Position = 7,
            Mandatory = $false,
            HelpMessage = "Manifest Path"
        )]
        [String]
        $Manifest,

        [Parameter(
            Position = 8,
            Mandatory = $false,
            HelpMessage = "Manifest Binaries"
        )]
        [String]
        $Binaries
    )
    
    $obj = [PSCustomObject]@{
        ID = $ID
        Bucket = $Bucket
        Version = $Version
        Name = $Name
        Description = $Description
        Website = $Website
        License = $License
        Path = $Path
        Binaries = $Binaries
    }

    return $obj
}
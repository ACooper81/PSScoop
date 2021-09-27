function Get-ScoopPackages
{
    [CmdletBinding()]
    param (
        [stiring]$searchstring = '*'
    )

    Invoke-Command(scoop list $searchstring)
}
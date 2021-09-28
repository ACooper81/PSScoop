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
            HelpMessage = "Manifest Path"
        )]
        [ValidateScript({Test-Path $_ -PathType 'leaf'})] 
        [String]
        $Path
    )

    begin {
        $obj = $null
    }

    process {
        if (Test-Path -Path $Path){
            $obj = Get-Content $Path | ConvertFrom-Json -AsHashtable
        }
    }
    
    end {
        $obj.Add("id", ([regex]::match($Path, "\\apps\\(.*?)\\").Groups[1].Value))
        $obj.Add("path", $Path)
        $bucket = ((Get-Content ((Get-Item $obj.path).Directory.ToString() + "\\scoop-install.json")) | ConvertFrom-Json -AsHashtable).bucket
        $obj.Add("bucket", $bucket)
        $obj | Add-Member -MemberType ScriptMethod -Name Update -Value {& scoop update $obj.ID}

        return $obj
    }
    
}
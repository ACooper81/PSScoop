<#
.SYNOPSIS
    Create scoop manifest object
.DESCRIPTION
    Creates a hashtable object with all the scoop manifest properties and some helpful methods
.EXAMPLE
    PS C:\> New-ScoopManifestObject "C:\Users\User\scoop\apps\7zip\current\scoop-manifest.json"
    This will create a hashtable object with the manifest details
.INPUTS
    Inputs Path String to the scoop manifest file
.OUTPUTS
    Outputs a hashtable object for the manifest file
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
        $obj.Add("path", $Path)
        if ($Path.Contains("scoop-manifest.json")){
            $obj.Add("id", ([regex]::match($Path, "\\apps\\(.*?)\\").Groups[1].Value))
            $bucket = ((Get-Content ((Get-Item $obj.path).Directory.ToString() + "\\scoop-install.json")) | ConvertFrom-Json -AsHashtable).bucket
            $obj.Add("bucket", $bucket)
            If ($Path.Contains("ProgramData")){
                $obj.Add("scope", "Global")
                $obj | Add-Member -MemberType ScriptMethod -Name Update -Value {& sudo scoop update $obj.id -g}
            } else{
                $obj.Add("scope", "User")
                $obj | Add-Member -MemberType ScriptMethod -Name Update -Value {& scoop update $obj.id}
            }
        }
        if ($Path.Contains("buckets")){
            $obj.Add("id", (Get-Item $Path).BaseName)
            $bucket = [regex]::match($Path, "\\buckets\\(.*?)\\").Groups[1].Value
            $obj.Add("bucket", $bucket)
            $obj | Add-Member -MemberType ScriptMethod -Name UserInstall -Value {& scoop install $obj.id}
            $obj | Add-Member -MemberType ScriptMethod -Name GlobalInstall -Value {& sudo scoop install $obj.id -g}
        }
        # $obj = $obj.GetEnumerator() | Sort-Object Name
        return $obj
    }
}
function Reset-Scoop {
    [CmdletBinding()]
    param (
        [Parameter(
            Position=1,
            Mandatory=$true,
            HelpMessage="Reset a list of apps using id")]
        [string[]]
        $App,

        [Parameter(
            Position=2,
            Mandatory=$false,
            HelpMessage="What version do you want to use")]
        [string]
        $Version = ""
    )
    
    begin {
        
    }
    
    process {
        foreach ($item in $App){
            if ($item -eq "*"){
                Invoke-Expression "&scoop reset *"
            }
            elseif($Version -ne ""){
                $command = "&scoop reset $item" + "@" + $Version
                Invoke-Expression $command
            }
            else{
                Invoke-Expression "&scoop reset $item"
            }
        }
    }
    
    end {
        
    }
}
#   Get the path to the function files...
$functionpath = $PSScriptRoot + "\function\"

#   Get a list of all the function file names...
$functionlist = Get-ChildItem -Path $functionpath -Name

#   Loop over all the files and dot source them into memory...
foreach ($function in $functionlist)
{
    ($functionpath + $function)
}
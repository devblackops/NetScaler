# Not playing slop
#Set-StrictMode -Version 3

$script:session = $null
$script:nitroSession = $null

# Load DLLs
$dll1 = Resolve-Path -Path "$PSScriptRoot\DLL\Newtonsoft.Json.dll"
[System.Reflection.Assembly]::LoadFile($dll1)
$dll2 = Resolve-Path -Path "$PSScriptRoot\DLL\nitro.dll"
[System.Reflection.Assembly]::LoadFile($dll2)


# Load public functions
$publicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public" -Recurse -Include *.ps1
foreach ($function in $publicFunctions) {
    . $function.FullName
}

# Load private functions
$privateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private" -Recurse -Include *.ps1
foreach ($function in $privateFunctions) {
    . $function.FullName
}

Export-ModuleMember -Function *NetScaler*
Export-ModuleMember -Function *-NS*
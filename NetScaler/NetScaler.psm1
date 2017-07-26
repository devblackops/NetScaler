<#
Copyright 2015 Brandon Olin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

# Not playing slop
Set-StrictMode -Version 3

$script:session = $null

# Load DLLs
#$dll1 = Resolve-Path -Path "$PSScriptRoot\DLL\Newtonsoft.Json.dll"
#[System.Reflection.Assembly]::LoadFile($dll1)
#$dll2 = Resolve-Path -Path "$PSScriptRoot\DLL\nitro.dll"
#[System.Reflection.Assembly]::LoadFile($dll2)

# Load public functions
$publicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public" -Recurse -Include *.ps1 -Exclude *.tests.ps1
foreach ($function in $publicFunctions) {
    . $function.FullName
}

# Load private functions
$privateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private" -Recurse -Include *.ps1 -Exclude *.tests.ps1
foreach ($function in $privateFunctions) {
    . $function.FullName
}

#Export-ModuleMember -Function *NetScaler*
#Export-ModuleMember -Function *-NS*
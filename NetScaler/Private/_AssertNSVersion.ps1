<#
Copyright 2016 Iain Brighton

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

function _AssertNSVersion {
    <#
    .SYNOPSIS
        Ensures that the NetScaler appliance's version meets the specified minimum version.

    .DESCRIPTION
        Ensures that the NetScaler appliance's version meets the specified minimum version.

    .PARAMETER Session
        An existing custom NetScaler Web Request Session object returned by Connect-NetScaler.

    .PARAMETER MinimumVersion
        Specifies the minimum version of NetScaler is required.

    .EXAMPLE
        _AssertNSVersion -Session $session -MinimumVersion '11.0'

        Ensure that the current session is a NetScaler 11.0 or later appliance.
    #>
    [cmdletbinding()]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [System.Version]$MinimumVersion
    )

    process {
        $nsVersion = Get-NSVersion -Session $Session
        if ($nsVersion.Version -lt $MinimumVersion) {
            $errorMessage = 'Netscaler version "{0}" is unsupported. Version "{1}" or later is required for this operation.'
            throw ($errorMessage -f $nsVersion.Version, $MinimumVersion)
        }
    }
}

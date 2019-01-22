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

function Add-NSDnsSuffix {
    <#
    .SYNOPSIS
        Add domain name suffix to NetScaler appliance.

    .DESCRIPTION
        Add domain name suffix to NetScaler appliance.

    .EXAMPLE
        Add-NSDnsSuffix -DNSSuffix 'lab.local'

        Adds the 'lab.local' DNS suffix to the NetScaler appliance.

    .EXAMPLE
        'lab.local', 'lab.internal' | Add-NSDnsSuffix -Session $session

        Adds the 'lab.local' and 'lab.internal' DNS suffixes to the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Suffix
        DNS search suffix to be appended when resolving domain names that are not fully qualified.

    .PARAMETER Force
        Suppress confirmation when adding a DNS suffix.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Suffix,

        [Switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Suffix) {
            if ($PSCmdlet.ShouldProcess($item, 'Add DNS suffix')) {
                try {
                    $params = @{
                         dnssuffix = $item;
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type dnssuffix -Payload $params -Action add | Out-Null
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

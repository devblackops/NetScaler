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

function Remove-NSDnsSuffix {
    <#
    .SYNOPSIS
        Removes a domain name suffix from the NetScaler appliance.

    .DESCRIPTION
        Removes a domain name suffix from the NetScaler appliance.

    .EXAMPLE
        Remove-NSDnsSuffix -DNSSuffix 'lab.local'

        Removes the 'lab.local' DNS suffix

    .EXAMPLE
        'lab.local', 'lab.internal' | Remove-NSDnsSuffix -Session $session

        Removes the 'lab.local' and 'lab.internal' DNS suffixes

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Suffix
        DNS search suffix to be removed.

    .PARAMETER Force
        Suppress confirmation when adding a DNS suffix.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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
             if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete DNS suffix')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type dnssuffix -Resource $item -Action delete
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

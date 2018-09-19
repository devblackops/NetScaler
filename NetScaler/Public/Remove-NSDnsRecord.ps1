<#
Copyright 2018 Iain Brighton

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

function Remove-NSDnsRecord {
    <#
    .SYNOPSIS
        Removes a domain name host/address record from the NetScaler appliance.

    .DESCRIPTION
        Removes a domain name host/address record from the NetScaler appliance.

    .EXAMPLE
        Remove-NSDnsRecord -Hostname 'storefront.lab.local'

        Removes the 'storefront.lab.local' DNS host/address record.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Hostname
        DNS host name/record to be removed.

    .PARAMETER Force
        Suppress confirmation when adding a DNS host/address record.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Hostname,

        [Switch]$Force
    )
    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Hostname) {
             if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete DNS record')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type dnsaddrec -Resource $item -Action delete
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

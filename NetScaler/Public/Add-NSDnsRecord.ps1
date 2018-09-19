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

function Add-NSDnsRecord {
    <#
    .SYNOPSIS
        Add a domain name server address record to NetScaler appliance.

    .DESCRIPTION
        Add a domain name server address record to NetScaler appliance.

    .EXAMPLE
        Add-NSDnsRecord -Hostname 'lab.local' -IPAddress '172.30.1.2'

        Adds the 'storefront.lab.local' DNS (host) record to the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Hostname
        Host name to add.

    .PARAMETER IPAddress
        One or more IPv4 addresses to assign to the domain name.

    .PARAMETER TTL
        Time to Live (TTL), in seconds, for the record.

        Default value: 3600
        Minimum value = 0
        Maximum value = 2147483647

    .PARAMETER ECSSubnet
        Subnet for which the cached address records need to be removed.

    .PARAMETER Force
        Suppress confirmation when adding DNS address record.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string]$Hostname,

        [parameter(Mandatory)]
        [string]$IPAddress,

        [ValidateRange(0, 2147483647)]
        [int]$TTL = 3600,

        [string]$ECSSubnet,

        [Switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Hostname, 'Add DNS address record')) {
            try {
                $params = @{
                        hostname = $Hostname;
                        ipaddress = $IPAddress;
                        ttl = $TTL;
                }
                if ($PSBoundParameters.ContainsKey('ECSSubnet')) {
                    $params['ecssubnet'] = $ECSSubnet
                }
                _InvokeNSRestApi -Session $Session -Method POST -Type dnsaddrec -Payload $params -Action add | Out-Null
            }
            catch {
                throw $_
            }
        }
    }
}

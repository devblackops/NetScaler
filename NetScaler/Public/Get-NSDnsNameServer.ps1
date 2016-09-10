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

function Get-NSDnsNameServer {
    <#
    .SYNOPSIS
        Gets the specified DNS name server object.

    .DESCRIPTION
        Gets the specified DNS name server object.

    .EXAMPLE
        Get-NSDnsNameServer

        Get all DNS name server objects.

    .EXAMPLE
        Get-NSDnsNameServer -IPAddress '192.168.0.10'

        Get the DNS name server object with the IP address of '192.168.0.10'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER IPAddress
        A filter to apply to the IPv4 address value.

    .PARAMETER DNSVServerName
        A filter to apply to the DNSVServerName value.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [string]$IPAddress,

        [string]$DNSVServerName
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            # Contruct a filter hash if we specified any filters
            $Filters = @{}
            if ($PSBoundParameters.ContainsKey('IPAddress')) {
                $Filters['ip'] = $IPAddress
            }
            if ($PSBoundParameters.ContainsKey('DNSVServerName')) {
                $Filters['dnsvservername'] = $DNSVServerName
            }
            _InvokeNSRestApiGet -Session $Session -Type dnsnameserver -Filters $Filters
        }
        catch {
            throw $_
        }
    }
}

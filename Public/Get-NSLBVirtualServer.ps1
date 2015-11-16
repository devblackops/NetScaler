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

function Get-NSLBVirtualServer {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [Parameter(Position=0)]
        [string]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [int]$Port,

        [ValidateSet('DHCPRA','DIAMTER', 'DNS', 'DNS_TCP', 'DLTS', 'FTP', 'HTTP', 'MSSQL', 'MYSQL', 'NNTP', 'PUSH','RADIUS', 'RDP', 'RTSP', 'SIP_UDP', 'SSL', 'SSL_BRIDGE', 'SSL_DIAMETER', 'SSL_PUSH', 'SSL_TCP', 'TCP', 'TFTP', 'UDP')]
        [string]$ServiceType,

        [ValidateSet('ROUNDROBIN', 'LEASTCONNECTION', 'LEASTRESPONSETIME', 'LEASTBANDWIDTH', 'LEASTPACKETS', 'CUSTOMLOAD', 'LRTM', 'URLHASH', 'DOMAINHASH', 'DESTINATIONIPHASH', 'SOURCEIPHASH', 'TOKEN', 'SRCIPDESTIPHASH', 'SRCIPSRCPORTHASH', 'CALLIDHASH')]
        [string]$LBMethod
    )

    begin {
        _AssertSessionActive
        $virtualServers = @()
    }

    process {
        # Contruct a filter array if we specified any filters
        [com.citrix.netscaler.nitro.util.filtervalue[]] $filters = @()
        if ($PSBoundParameters.ContainsKey('Name')) {
            $filters += New-Object -TypeName com.citrix.netscaler.nitro.util.filtervalue -ArgumentList @('name', $Name)
        }
        if ($PSBoundParameters.ContainsKey('Port')) {
            $filters += New-Object -TypeName com.citrix.netscaler.nitro.util.filtervalue -ArgumentList @('port', $Port)
        }
        if ($PSBoundParameters.ContainsKey('ServiceType')) {
            $filters += New-Object -TypeName com.citrix.netscaler.nitro.util.filtervalue -ArgumentList @('servicetype', $ServiceType)
        }
        if ($PSBoundParameters.ContainsKey('LBMethod')) {
            $filters += New-Object -TypeName com.citrix.netscaler.nitro.util.filtervalue -ArgumentList @('lbmethod', $LBMethod)
        }

        # If we specified any filters, filter based on them
        # Otherwise, get everything        
        if ($filters.count -gt 0) {
            $virtualServers = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::get_filtered($Session, $filters)
        } else {
            $virtualServers = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::get($Session)
        }

        $virtualServers
    }
}
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

function New-NSLBVirtualServer {
    <#
    .SYNOPSIS
        Creates a new load balancer virtual server.

    .DESCRIPTION
        Creates a new load balancer virtual server.

    .EXAMPLE
        New-NSLBVirtualServer -Name 'vserver01' -IPAddress '10.10.10.10'

        Create a new virtual server named 'vserver01' with an IP address of '10.10.10.10'

    .EXAMPLE
        New-NSLBVirtualServer -Name 'vserver01' -IPAddress '10.10.10.10' -Port 8080 -ServiceType 'HTTP' -LBMethod 'ROUNDROBIN'
    
        Create a new virtual server named 'vserver01' listening on port 8080 with a load balancing method of 'ROUNDROBIN'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the virtual servers to create.

    .PARAMETER IPAddress
        The IP address for the new virtual server.

    .PARAMETER Comment
        The comment associated with the new virtual server.

    .PARAMETER Port
        The port the new virtual server will listen on.

    .PARAMETER ServiceType
        The service type for the virtual server.

    .PARAMETER LBMethod
        The load balancing method for the new virtual server.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

        [ValidateRange(1, 65534)]
        [int]$Port = 80,

        [ValidateSet('DHCPRA','DIAMTER', 'DNS', 'DNS_TCP', 'DLTS', 'FTP', 'HTTP', 'MSSQL', 'MYSQL', 'NNTP', 'PUSH','RADIUS', 'RDP', 'RTSP', 'SIP_UDP', 'SSL', 'SSL_BRIDGE', 'SSL_DIAMETER', 'SSL_PUSH', 'SSL_TCP', 'TCP', 'TFTP', 'UDP')]
        [string]$ServiceType = 'HTTP',

        [ValidateSet('ROUNDROBIN', 'LEASTCONNECTION', 'LEASTRESPONSETIME', 'LEASTBANDWIDTH', 'LEASTPACKETS', 'CUSTOMLOAD', 'LRTM', 'URLHASH', 'DOMAINHASH', 'DESTINATIONIPHASH', 'SOURCEIPHASH', 'TOKEN', 'SRCIPDESTIPHASH', 'SRCIPSRCPORTHASH', 'CALLIDHASH')]
        [string]$LBMethod = 'ROUNDROBIN',

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Virtual Server')) {
                $vs = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.lb.lbvserver
                $vs.name = $item
                $vs.comment = $comment
                $vs.servicetype = $ServiceType
                $vs.ipv46 = $IPAddress
                $vs.port = $Port
                $vs.lbmethod = $LBMethod

                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::add($session, $vs)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Name $item
                }
            }
        }
    }
}
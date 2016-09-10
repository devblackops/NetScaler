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

function New-NSCSVirtualServer {
    <#
    .SYNOPSIS
        Creates a new content switching virtual server.

    .DESCRIPTION
        Creates a new content switching virtual server.

    .EXAMPLE
        New-NSCSVirtualServer -Name 'vserver01' -IPAddress '10.10.10.10'

        Create a new content switching virtual server named 'vserver01' with an IP address of '10.10.10.10'

    .EXAMPLE
        New-NSCSVirtualServer -Name 'vserver01' -IPAddress '10.10.10.10' -Port 8080 -ServiceType 'HTTP' -State 'DISABLED'

        Create a new disabled content switching virtual server named 'vserver01' listening on port 8080.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the content switching virtual server. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@), equal sign (=), and hyphen (-) characters.
        Cannot be changed after the CS virtual server is created.

        Minimum length = 1

    .PARAMETER IPAddress
        IPv4 or IPv6 address to assign to the virtual server.

    .PARAMETER Port
        Port number for content switching virtual server.

        Range 1 - 65535

    .PARAMETER ServiceType
        Protocol used by the virtual server.

        Possible values = HTTP, SSL, TCP, FTP, RTSP, SSL_TCP, UDP, DNS, SIP_UDP, SIP_TCP, SIP_SSL, ANY, RADIUS, RDP, MYSQL, MSSQL, DIAMETER, SSL_DIAMETER, DNS_TCP, ORACLE, SMPP

    .PARAMETER State
        Initial state of the load balancing virtual server.
        Default value: ENABLED

        Possible values = ENABLED, DISABLED

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateRange(1, 65534)]
        [int]$Port = 80,

        [ValidateSet('HTTP', 'SSL', 'TCP', 'FTP', 'RTSP', 'SSL_TCP', 'UDP', 'DNS', 'SIP_UDP', 'SIP_TCP', 'SIP_SSL', 'ANY', 'RADIUS', 'RDP', 'MYSQL', 'MSSQL', 'DIAMETER', 'SSL_DIAMETER', 'DNS_TCP', 'ORACLE', 'SMPP')]
        [string]$ServiceType = 'HTTP',

        [Parameter()]
        [ValidateSet('ENABLED', 'DISABLED')]
        [string]
        $State = 'ENABLED',

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Virtual Server')) {
                try {
                    $params = @{
                        name = $item
                        servicetype = $ServiceType
                        ipv46 = $IPAddress
                        port = $Port
                        state = $State
                    }

                    _InvokeNSRestApi -Session $Session -Method POST -Type csvserver -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSCSVirtualServer -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
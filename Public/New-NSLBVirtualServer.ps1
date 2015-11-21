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
        Name for the virtual server. Must begin with an ASCII alphanumeric or underscore (_) character, 
        and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@),
        equal sign (=), and hyphen (-) characters. Can be changed after the virtual server is created. 
    
        Minimum length = 1

    .PARAMETER IPAddress
        IPv4 or IPv6 address to assign to the virtual server.

    .PARAMETER Comment
        Any comments that you might want to associate with the virtual server.

    .PARAMETER Port
        Port number for the virtual server.

        Range 1 - 65535

    .PARAMETER ServiceType
        Protocol used by the service (also called the service type).

        Possible values = HTTP, FTP, TCP, UDP, SSL, SSL_BRIDGE, SSL_TCP, DTLS, NNTP, DNS, DHCPRA, ANY, SIP_UDP, 
        DNS_TCP, RTSP, PUSH, SSL_PUSH, RADIUS, RDP, MYSQL, MSSQL, DIAMETER, SSL_DIAMETER, TFTP, ORACLE

    .PARAMETER LBMethod
        Load balancing method. 
    
        The available settings function as follows: 
        * ROUNDROBIN - Distribute requests in rotation, regardless of the load. Weights can be assigned to services 
        to enforce weighted round robin distribution.
        * LEASTCONNECTION (default) - Select the service with the fewest connections. 
        * LEASTRESPONSETIME - Select the service with the lowest average response time. 
        * LEASTBANDWIDTH - Select the service currently handling the least traffic. 
        * LEASTPACKETS - Select the service currently serving the lowest number of packets per second. 
        * CUSTOMLOAD - Base service selection on the SNMP metrics obtained by custom load monitors. 
        * LRTM - Select the service with the lowest response time. Response times are learned through monitoring probes. 
            This method also takes the number of active connections into account. Also available are a number of hashing methods, 
            in which the appliance extracts a predetermined portion of the request, creates a hash of the portion, and then checks
            whether any previous requests had the same hash value. If it finds a match, it forwards the request to the service 
            that served those previous requests. Following are the hashing methods: 
        * URLHASH - Create a hash of the request URL (or part of the URL).
        * DOMAINHASH - Create a hash of the domain name in the request (or part of the domain name). The domain name is taken from
            either the URL or the Host header. If the domain name appears in both locations, the URL is preferred. If the request
            does not contain a domain name, the load balancing method defaults to LEASTCONNECTION.
        * DESTINATIONIPHASH - Create a hash of the destination IP address in the IP header.
        * SOURCEIPHASH - Create a hash of the source IP address in the IP header.
        * TOKEN - Extract a token from the request, create a hash of the token, and then select the service to which any previous
            requests with the same token hash value were sent. 
        * SRCIPDESTIPHASH - Create a hash of the string obtained by concatenating the source IP address and destination IP address
            in the IP header.
        * SRCIPSRCPORTHASH - Create a hash of the source IP address and source port in the IP header.
        * CALLIDHASH - Create a hash of the SIP Call-ID header.
        
        Default value: LEASTCONNECTION
        Possible values = ROUNDROBIN, LEASTCONNECTION, LEASTRESPONSETIME, URLHASH, DOMAINHASH, DESTINATIONIPHASH, SOURCEIPHASH,
        SRCIPDESTIPHASH, LEASTBANDWIDTH, LEASTPACKETS, TOKEN, SRCIPSRCPORTHASH, LRTM, CALLIDHASH, CUSTOMLOAD, LEASTREQUEST

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
                try {
                    $params = @{
                        name = $item
                        comment = $comment
                        servicetype = $ServiceType
                        ipv46 = $IPAddress
                        port = $Port
                        lbmethod = $LBMethod
                    }
                    $response = _InvokeNSRestApi -Session $Session -Method POST -Type lbvserver -Payload $params -Action add
                    if ($response.errorcode -ne 0) { throw $response }

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBVirtualServer -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
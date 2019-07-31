<#
Copyright 2019 Olli Janatuinen

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

function New-NSLBService {
    <#
    .SYNOPSIS
        Adds a load balancer service.

    .DESCRIPTION
        Adds a load balancer service.

    .EXAMPLE
        New-NSLBService -Name 'sg01'

        Creates a new service called 'sg01'

    .EXAMPLE
        'sg01' | New-NSLBService -ServiceType HTTP -Comment 'test service'
    
        Creates a new HTTP service called 'sg01' with a comment.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the service to create.

    .PARAMETER ServerName
        The name of the backend server.

    .PARAMETER ServiceType
        Protocol used to exchange data with the service.

    .PARAMETER TrafficDomainId
        Integer value that uniquely identifies the traffic domain in which you want to configure the entity.
        If you do not specify an ID, the entity becomes part of the default traffic domain, which has an ID of 0.

    .PARAMETER Port
        TCP port.

    .PARAMETER CacheType
        Cache type supported by the cache server.

    .PARAMETER Cacheable
        Use the transparent cache redirection virtual server to forward the request to the cache server.
        Note: Do not set this parameter if you set the Cache Type.
        Default value: NO
        Possible values = YES, NO

    .PARAMETER State
        Initial state of the service.
        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER HealthMonitor
        Monitor the health of this service. 
        Available settings function as follows: 
            YES - Send probes to check the health of the service. 
            NO - Do not send probes to check the health of the service. 
                 With the NO option, the appliance shows the service as UP at all times.
        Default value: YES
        Possible values = YES, NO

    .PARAMETER AppFlowLog
        Enable logging of AppFlow information for the specified service.
        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER Comment
        Any information about the service.

    .PARAMETER SureConnect
        State of the SureConnect feature for the service.
        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER SurgeProtection
        Enable surge protection for the service.
        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER UseProxyPort
        Use the proxy port as the source port when initiating connections with the server. 
        With the NO setting, the client-side connection port is used as the source port for the server-side connection. 
        Note: This parameter is available only when the Use Source IP (USIP) parameter is set to YES.
        Possible values = YES, NO

    .PARAMETER DownStateFlush
        Flush all active transactions associated with all the services in the service whose state transitions from UP to DOWN. 
        Note: Do not enable this option for applications that must complete their transactions.
        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER UseClientIP
        Use client's IP address as the source IP address when initiating connection to the server. 
        With the NO setting, which is the default, a mapped IP (MIP) address or subnet IP (SNIP) address 
        is used as the source IP address to initiate server side connections.
        Possible values = YES, NO

    .PARAMETER ClientKeepAlive
        Enable client keep-alive for the service.
        Possible values = YES, NO

    .PARAMETER TCPBuffering
        Enable TCP buffering for the service.
        Possible values = YES, NO

    .PARAMETER HTTPCompression
        Enable compression for the specified service.
        Possible values = YES, NO

    .PARAMETER ClientIP
        Insert the Client IP header in requests forwarded to the service.
        Possible values = ENABLED, DISABLED

    .PARAMETER ClientIPHeader
        Name of the HTTP header whose value must be set to the IP address of the client. 
        Used with the Client IP parameter. If client IP insertion is enabled, and the 
        client IP header is not specified, the value of Client IP Header parameter or the 
        value set by the set ns config command is used as client's IP header name.
        Minimum length = 1

    .PARAMETER MaxBandwithKbps
        Maximum bandwidth, in Kbps, allocated for all the services in the service.
        Minimum value = 0
        Maximum value = 4294967287

    .PARAMETER MonitorThreshold
        Minimum sum of weights of the monitors that are bound to this service. 
        Used to determine whether to mark a service as UP or DOWN.
        Minimum value = 0
        Maximum value = 65535

    .PARAMETER MaxRequests
        Maximum number of requests that can be sent on a persistent connection to the service.
        Note: Connection requests beyond this value are rejected.
        Minimum value = 0
        Maximum value = 65535

    .PARAMETER MaxClients
        Maximum number of simultaneous open connections for the service.
        Minimum value = 0
        Maximum value = 4294967294

    .PARAMETER ClientIdleTimeout
        Time, in seconds, after which to terminate an idle client connection.
        Minimum value = 0
        Maximum value = 31536000

    .PARAMETER ServerIdleTimeout        
        Time, in seconds, after which to terminate an idle server connection.
        Minimum value = 0
        Maximum value = 31536000

    .PARAMETER Passthru
        Return the newly created service.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB service name'),

        [parameter(Mandatory, Position = 1)]
        [string]$ServerName = (Read-Host -Prompt 'Server name'),

        [ValidateSet('ADNS','ADNS_TCP','ANY','DHCPRA','DIAMETER','DNS','DNS_TCP','DTLS','FTP','HTTP','MSSQL','MYSQL','NNTP','RADIUS','RDP','RPCSVR','RTSP','SIP_UDP','SNMP','SSL','SSL_BRIDGE','SSL_DIAMETER','SSL_TCP','TCP','TFTP','UDP')]
        [Alias('Protocol')]
        [string]$ServiceType = 'HTTP',

        [ValidateRange(0, 4094)]
        [int]$TrafficDomainId,

        [ValidateRange(1, 65535)]
        [int]$Port,

        [ValidateSet('SERVER', 'FORWARD', 'TRANSPARENT', 'REVERSE')]
        [string]$CacheType,

        [ValidateSet('NO', 'YES')]
        [string]$Cacheable = 'NO',

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$State = 'ENABLED',

        [ValidateSet('NO', 'YES')]
        [string]$HealthMonitor = 'YES',

        [ValidateSet('DISABLED', 'ENABLED')]
        [string]$AppFlowLog = 'ENABLED',

        [ValidateLength(0, 256)]
        [string]$Comment = [string]::Empty,

        [ValidateSet('ON', 'OFF')]
        [string]$SureConnect = 'OFF',

        [ValidateSet('ON', 'OFF')]
        [string]$SurgeProtection = 'OFF',

        [ValidateSet('YES','NO')]
        [string]$UseProxyPort = 'YES',

        [ValidateSet('ENABLED','DISABLED')]
        [string]$DownStateFlush = 'ENABLED',

        [ValidateSet('YES','NO')]
        [string]$UseClientIP = 'NO',

        [ValidateSet('YES','NO')]
        [string]$ClientKeepAlive = 'NO',

        [ValidateSet('YES', 'NO')]
        [string]$TCPBuffering = 'NO',

        [ValidateSet('YES', 'NO')]
        [string]$HTTPCompression = 'YES',

        [ValidateSet('ENABLED','DISABLED')]
        [string]$ClientIP = 'DISABLED',

        [string]$ClientIPHeader,

        [ValidateRange(0, 4294967287)]
        [int]$MaxBandwithKbps,

        [ValidateRange(0, 65535)]
        [int]$MonitorThreshold,

        [ValidateRange(0, 65535)]
        [int]$MaxRequests,

        [ValidateRange(0, 4294967294)]
        [int]$MaxClients,

        [ValidateRange(0, 31536000)]
        [int]$ClientIdleTimeout = 180,

        [ValidateRange(0, 31536000)]
        [int]$ServerIdleTimeout = 360,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Service')) {
                try {
                    $params = @{
                        name = $item
						servername = $ServerName
                        servicetype = $ServiceType
						port = $Port
                        state = $State
                        comment = $Comment
                        cacheable = $Cacheable
                        healthmonitor = $HealthMonitor
                        appflowlog = $AppFlowLog
                        sc = $SureConnect
                        sp = $SurgeProtection
                        useproxyport = $UseProxyPort
                        downstateflush = $DownStateFlush
                        usip = $UseClientIP
                        cka = $ClientKeepAlive
                        tcpb = $TCPBuffering
                        cip = $ClientIP
                        clttimeout = $ClientIdleTimeout
                        svrtimeout = $ServerIdleTimeout
                    }
                    if ($PSBoundParameters.ContainsKey('HTTPCompression')) {
                        $params.Add('cmp', $HTTPCompression)
                    }
                    if ($PSBoundParameters.ContainsKey('TrafficDomainId')) {
                        $params.Add('td', $TrafficDomainId)
                    }
                    if ($PSBoundParameters.ContainsKey('CacheType')) {
                        $params.Add('cachetype', $CacheType)
                    }
                    if ($ClientIP -eq 'ENABLED') {
                        $params.Add('cipheader', $ClientIPHeader)
                    }
                    if ($PSBoundParameters.ContainsKey('MaxBandwithKbps')) {
                        $params.Add('maxbandwidth', $MaxBandwithKbps)
                    }
                    if ($PSBoundParameters.ContainsKey('MonitorThreshold')) {
                        $params.Add('monthreshold', $MonitorThreshold)
                    }
                    if ($PSBoundParameters.ContainsKey('MaxRequests')) {
                        $params.Add('maxreq', $MaxRequests)
                    }
                    if ($PSBoundParameters.ContainsKey('MaxClients')) {
                        $params.Add('maxclient', $MaxClients)
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type service -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBService -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
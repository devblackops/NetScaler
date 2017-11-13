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

function Set-NSLBServiceGroup {
    <#
    .SYNOPSIS
        Updates an existing load balancer virtual server.

    .DESCRIPTION
        Updates an existing load balancer virtual server.

    .EXAMPLE
        Set-NSLBServiceGroup -Name 'sg01' -Comment 'This is a comment'

        Updates the comment for virtual server 'sg01'.

    .EXAMPLE
        Set-NSLBServiceGroup -Name 'sg01' HTTPCompression = 'ON'

        Enable the HTTP compression feature for service group 'sg01'.

    .EXAMPLE
        Set-NSLBServiceGroup -Name 'sg01' MaxBandwidthKbps 819200

        Set the maximum bandwidth for service group 'sg01' to 819200 Kbps.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the service groups to update.

    .PARAMETER State
        Initial state of the service group.
        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER AutoScale
        Auto scale option for a servicegroup.
        Default value: DISABLED
        Possible values = DISABLED, DNS, POLICY

    .PARAMETER Cacheable
        Use the transparent cache redirection virtual server to forward the request to the cache server.

    .PARAMETER HealthMonitor
        Monitor the health of this service.

    .PARAMETER AppFlowLog
        Enable logging of AppFlow information.

    .PARAMETER Comment
        The comment associated with the virtual server.

    .PARAMETER SureConnect
        State of the SureConnect feature.

    .PARAMETER SurgeProtection
        Enable surge protection.

    .PARAMETER UseProxyPort
        Use the proxy port as the source port when initiating connections with the server.

    .PARAMETER DownStateFlush
        Flush all active transactions associated with all the services in the service group whose state transitions from UP to DOWN.

    .PARAMETER UseClientIP
        Use client's IP address as the source IP address when initiating connection to the server.

    .PARAMETER TCPBuffering
        Enable TCP buffering for the service group.

    .PARAMETER HTTPCompression
        Enable compression.

    .PARAMETER ClientIP
        Insert the Client IP header in requests forwarded to the service.

    .PARAMETER MaxBandwidthKbps
        Maximum bandwidth, in Kbps, allocated for all the services in the service group.

    .PARAMETER MonitorThreshold
        Minimum sum of weights of the monitors that are bound to this service.

    .PARAMETER MaxRequests
        Maximum number of requests that can be sent on a persistent connection to the service group.

    .PARAMETER MaxClients
        Maximum number of simultaneous open connections for the service group.

    .PARAMETER ClientIdleTimeout
        Time, in seconds, after which to terminate an idle client connection.

    .PARAMETER ServerIdleTimeout
        Time, in seconds, after which to terminate an idle server connection.

    .PARAMETER Force
        Suppress confirmation when updating a service group.

    .PARAMETER Passthru
        Return the service group object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB service group name'),

        [ValidateSet('SERVER', 'FORWARD', 'TRANSPARENT', 'REVERSE')]
        [string]$CacheType,

        [ValidateSet('DISABLED', 'DNS', 'POLICY')]
        [string]$AutoScale = 'DISABLED',

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

        [ValidateRange(0, 4294967287)]
        [int]$MaxBandwidthKbps,

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

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Service Group')) {
                $params = @{
                    servicegroupname = $item
                }
                if ($PSBoundParameters.ContainsKey('State')) {
                    $params.Add('state', $State)
                }
                if ($PSBoundParameters.ContainsKey('CacheType')) {
                    $params.Add('cachetype', $CacheType)
                }
                if ($PSBoundParameters.ContainsKey('Cacheable')) {
                    $params.Add('cacheable', $Cacheable)
                }
                if ($PSBoundParameters.ContainsKey('AutoScale')) {
                    $params.Add('autoScale', $AutoScale)
                }
                if ($PSBoundParameters.ContainsKey('HealthMonitor')) {
                    $params.Add('healthmonitor', $HealthMonitor)
                }
                if ($PSBoundParameters.ContainsKey('AppFlowLog')) {
                    $params.Add('appflowlog', $AppFlowLog)
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $params.Add('comment', $Comment)
                }
                if ($PSBoundParameters.ContainsKey('SureConnect')) {
                    $params.Add('sc', $SureConnect)
                }
                if ($PSBoundParameters.ContainsKey('SurgeProtection')) {
                    $params.Add('sp', $SurgeProtection)
                }
                if ($PSBoundParameters.ContainsKey('UseProxyPort')) {
                    $params.Add('useproxyport', $UseProxyPort)
                }
                if ($PSBoundParameters.ContainsKey('DownStateFlush')) {
                    $params.Add('downstateflush', $DownStateFlush)
                }
                if ($PSBoundParameters.ContainsKey('UseClientIP')) {
                    $params.Add('usip', $UseClientIP)
                }
                if ($PSBoundParameters.ContainsKey('ClientKeepAlive')) {
                    $params.Add('cka', $ClientKeepAlive)
                }
                if ($PSBoundParameters.ContainsKey('TCPBuffering')) {
                    $params.Add('tcpb', $TCPBuffering)
                }
                if ($PSBoundParameters.ContainsKey('HTTPCompression')) {
                    $params.Add('cmp', $HTTPCompression)
                }
                if ($PSBoundParameters.ContainsKey('ClientIP')) {
                    $params.Add('cip', $ClientIP)
                }
                if ($PSBoundParameters.ContainsKey('MaxBandwidthKbps')) {
                    $params.Add('maxbandwidth', $MaxBandwidthKbps)
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
                if ($PSBoundParameters.ContainsKey('ClientIdleTimeout')) {
                    $params.Add('clttimeout', $ClientIdleTimeout)
                }
                if ($PSBoundParameters.ContainsKey('ServerIdleTimeout')) {
                    $params.Add('svrtimeout', $ServerIdleTimeout)
                }

                _InvokeNSRestApi -Session $Session -Method PUT -Type servicegroup -Payload $params -Action update

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServiceGroup -Session $Session -Name $item
                }
            }
        }
    }
}
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

function New-NSLBServiceGroup {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB service group name'),

        [ValidateSet('ADNS','ADNS_TCP','ANY','DHCPRA','DIAMETER','DNS','DNS_TCP','DTLS','FTP','HTTP','MSSQL','MYSQL','NNTP','RADIUS','RDP','RPCSVR','RTSP','SIP_UDP','SNMP','SSL','SSL_BRIDGE','SSL_DIAMETER','SSL_TCP','TCP','TFTP','UDP')]
        [Alias('Protocol')]
        [string]$ServiceType = 'HTTP',

        [ValidateRange(0, 4094)]
        [int]$TrafficDomainId,

        [ValidateSet('FORWARD', 'TRANSPARENT', 'REVERSE')]
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
        [string]$Comment = '',

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
            if ($PSCmdlet.ShouldProcess($item, 'Create Service Group')) {
                $sg = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.basic.servicegroup
                $sg.servicegroupname = $item
                $sg.servicetype = $ServiceType
                if ($PSBoundParameters.ContainsKey('TrafficDomainId')) {
                    $sg.td = $TrafficDomainId
                }
                if ($PSBoundParameters.ContainsKey('CacheType')) {
                    $sg.cachetype = $CacheType
                }
                if ($PSBoundParameters.ContainsKey('AutoScale')) {
                    $sg.autoscale = $AutoScale
                }
                if ($PSBoundParameters.ContainsKey('Cacheable')) {
                    $sg.cacheable = $Cacheable
                }
                $sg.state = $State
                if ($PSBoundParameters.ContainsKey('HealthMonitor')) {
                    $sg.healthmonitor = $HealthMonitor
                }
                if ($PSBoundParameters.ContainsKey('AppFlowLog')) {
                    $sg.appflowlog = $AppFlowLog
                }
                $sg.comment = $Comment
                if ($PSBoundParameters.ContainsKey('SureConnect')) {
                    $sg.sc = $SureConnect
                }
                if ($PSBoundParameters.ContainsKey('SurgeProtection')) {
                    $sg.sp = $SurgeProtection
                }
                if ($PSBoundParameters.ContainsKey('UseProxyPort')) {
                    $sg.useproxyport = $UseProxyPort
                }
                if ($PSBoundParameters.ContainsKey('DownStateFlush')) {
                    $sg.downstateflush = $DownStateFlush
                }
                if ($PSBoundParameters.ContainsKey('UseClientIP')) {
                    $sg.usip = $UseClientIP
                }
                if ($PSBoundParameters.ContainsKey('ClientKeepAlive')) {
                    $sg.cka = $ClientKeepAlive
                }
                if ($PSBoundParameters.ContainsKey('TCPBuffering')) {
                    $sg.tcpb = $TCPBuffering
                }
                if ($PSBoundParameters.ContainsKey('HTTPCompression')) {
                    $sg.cmp = $HTTPCompression
                }
                if ($PSBoundParameters.ContainsKey('ClientIP')) {
                    $sg.cip = $ClientIP
                }
                if ($ClientIP -eq 'ENABLED') {
                    $sg.cipheader = $ClientIPHeader
                }
                if ($PSBoundParameters.ContainsKey('MaxBandwithKbps')) {
                    $sg.maxbandwidth = $MaxBandwithKbps
                }
                if ($PSBoundParameters.ContainsKey('MonitorThreshold')) {
                    $sg.monthreshold = $MonitorThreshold
                }
                if ($PSBoundParameters.ContainsKey('MaxRequests')) {
                    $sg.maxreq = $MaxRequests
                }
                if ($PSBoundParameters.ContainsKey('MaxClients')) {
                    $sg.maxclient = $MaxClients
                }
                if ($PSBoundParameters.ContainsKey('ClientIdleTimeout')) {
                    $sg.clttimeout = $ClientIdleTimeout
                }
                if ($PSBoundParameters.ContainsKey('ServerIdleTimeout')) {
                    $sg.svrtimeout = $ServerIdleTimeout
                }

                $result = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup]::add($session, $sg)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServiceGroup -Name $item
                }
            }
        }
    }
}
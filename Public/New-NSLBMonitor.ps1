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

function New-NSLBMonitor {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string[]]$Name = (Read-Host -Prompt 'Monitor name'),

        [ValidateSet('PING', 'TCP', 'HTTP', 'TCP-ECV', 'HTTP-ECV', 'UDP-ECV', 'DNS', 'FTP', 'LDNS-PING', 
            'LDNS-TCP', 'RADIUS', 'USER', 'HTTP-INLINE', 'SIP-UDP', 'LOAD', 'FTP-EXTENDED', 'SMTP', 'SNMP', 
            'NNTP', 'MYSQL', 'MYSQL-ECV', 'MSSQL-ECV', 'ORACLE-ECV', 'LDAP', 'POP3', 'CITRIX-XML-SERVICE', 
            'CITRIX-WEB-INTERFACE', 'DNS-TCP', 'RTSP', 'ARP', 'CITRIX-AG', 'CITRIX-AAC-LOGINPAGE', 'CITRIX-AAC-LAS', 
            'CITRIX-XD-DDC', 'ND6', 'CITRIX-WI-EXTENDED', 'DIAMETER', 'RADIUS_ACCOUNTING', 'STOREFRONT')]
        [string]$Type = 'PING',

        [ValidateRange(1, 20940000)]
        [int]$Interval = 5,

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$IntervalType = 'SEC',

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$DestinationIP,

        [ValidateRange(1, 20939000)]
        [int]$ResponseTimeout = 2,

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$ResponseTimeoutType = 'SEC',

        [int]$DestinationPort,

        [ValidateRange(1, 20939000)]
        [int]$Downtime = 30,

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$DowntimeType = 'SEC',

        [ValidateRange(0, 20939000)]
        [int]$Deviation,

        [ValidateRange(1, 127)]
        [int]$Retries = 3,

        [ValidateRange(0, 100)]
        [int]$ResponseTimeoutThreshold,

        [ValidateRange(0, 32)]
        [int]$AlertRetries,

        [ValidateRange(0, 32)]
        [int]$SuccessRetries = 1, 

        [ValidateRange(0, 32)]
        [int]$FailureRetries,

        [ValidateRange(1, 127)]
        [string]$NetProfile,

        [ValidateSet('YES', 'NO')]
        [string]$TOS = 'NO',

        [ValidateRange(1, 63)]
        [int]$TOSID,

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$state = 'ENABLED',

        [ValidateSet('Yes', 'NO')]
        [string]$Reverse = 'NO',

        [ValidateSet('YES', 'NO')]
        [string]$Transparent = 'NO', 

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$LRTM = 'DISABLED',

        [ValidateSet('YES', 'NO')]
        [string]$Secure = 'NO',

        [ValidateSet('YES', 'NO')]
        [string]$IPTunnel = 'NO',

        [string]$ScriptName,

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$DispatcherIP, 

        [int]$DispatcherPort,

        [string]$ScriptArgs,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Server')) {
                $m = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.lb.lbmonitor
                $m.monitorname = $name
                $m.type = $Type
                $m.interval = $Interval
                $m.units3 = $IntervalType
                if ($PSBoundParameters.ContainsKey('DestinationIP')) {
                    $m.destip = $DestinationIP
                }
                $m.resptimeout = $ResponseTimeout
                $m.units4 = $ResponseTimeoutType
                if ($PSBoundParameters.ContainsKey('DestinationPort')) {
                    $m.destport = $DestinationPort
                }
                $m.downtime = $Downtime
                $m.units2 = $DowntimeType
                if ($PSBoundParameters.ContainsKey('Deviation')) {
                    $m.deviation = $Deviation
                }
                $m.retries = $Retries
                if ($PSBoundParameters.ContainsKey('ResponseTimeoutThreshold')) {
                    $m.resptimeoutthresh = $ResponseTimeoutThreshold
                }
                if ($PSBoundParameters.ContainsKey('AlertRetries')) {
                    $m.alertretries = $AlertRetries
                }
                $m.successretries = $SuccessRetries
                if ($PSBoundParameters.ContainsKey('FailureRetries')) {
                    $m.failureretries = $FailureRetries
                }
                if ($PSBoundParameters.ContainsKey('NetProfile')) {
                    $m.netprofile = $NetProfile
                }
                $m.tos = $TOS
                if ($PSBoundParameters.ContainsKey('TOSID')) {
                    $m.tosid = $TOSID
                }
                $m.state = $state
                $m.reverse = $Reverse
                $m.transparent = $Transparent
                $m.lrtm = $LRTM
                $m.secure = $Secure
                $m.iptunnel = $IPTunnel
                if ($PSBoundParameters.ContainsKey('ScriptName')) {
                    $m.scriptname = $ScriptName
                }
                if ($PSBoundParameters.ContainsKey('DispatcherIP')) {
                    $m.dispatcherip = $DispatcherIP
                }
                if ($PSBoundParameters.ContainsKey('ScriptArgs')) {
                    $m.scriptargs = $ScriptArgs
                }
                
                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbmonitor]::add($session, $m)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBMonitor -Name $item
                }
            }
        }
    }
}
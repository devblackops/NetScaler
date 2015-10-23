function New-NSLBMonitor {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string[]]$Name, #monitorname

        [ValidateSet('PING', 'TCP', 'HTTP', 'TCP-ECV', 'HTTP-ECV', 'UDP-ECV', 'DNS', 'FTP', 'LDNS-PING', 
            'LDNS-TCP', 'RADIUS', 'USER', 'HTTP-INLINE', 'SIP-UDP', 'LOAD', 'FTP-EXTENDED', 'SMTP', 'SNMP', 
            'NNTP', 'MYSQL', 'MYSQL-ECV', 'MSSQL-ECV', 'ORACLE-ECV', 'LDAP', 'POP3', 'CITRIX-XML-SERVICE', 
            'CITRIX-WEB-INTERFACE', 'DNS-TCP', 'RTSP', 'ARP', 'CITRIX-AG', 'CITRIX-AAC-LOGINPAGE', 'CITRIX-AAC-LAS', 
            'CITRIX-XD-DDC', 'ND6', 'CITRIX-WI-EXTENDED', 'DIAMETER', 'RADIUS_ACCOUNTING', 'STOREFRONT')]
        [string]$Type = 'PING', #type

        [ValidateRange(1, 20940000)]
        [int]$Interval = 5, #interval

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$IntervalType = 'SEC', #units3

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$DestinationIP, #destip

        [ValidateRange(1, 20939000)]
        [int]$ResponseTimeout = 2, #resptimeout

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$ResponseTimeoutType = 'SEC', #units4

        [int]$DestinationPort, #destport

        [ValidateRange(1, 20939000)]
        [int]$Downtime = 30, #downtime 

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$DowntimeType = 'SEC', #units2

        [ValidateRange(0, 20939000)]
        [int]$Deviation, #deviation

        [ValidateRange(1, 127)]
        [int]$Retries = 3, #retries

        [ValidateRange(0, 100)]
        [int]$ResponseTimeoutThreshold, #resptimeoutthresh

        [ValidateRange(0, 32)]
        [int]$AlertRetries, #alertretries

        [ValidateRange(0, 32)]
        [int]$SuccessRetries = 1, # successretries 

        [ValidateRange(0, 32)]
        [int]$FailureRetries, #failureretries

        [ValidateRange(1, 127)]
        [string]$NetProfile, #netprofile

        [ValidateSet('YES', 'NO')]
        [string]$TOS = 'NO', #tos

        [ValidateRange(1, 63)]
        [int]$TOSID, #tosid

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$state = 'ENABLED', #state

        [ValidateSet('Yes', 'NO')]
        [string]$Reverse = 'NO', #reverse

        [ValidateSet('YES', 'NO')]
        [string]$Transparent = 'NO', #transparent 

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$LRTM = 'DISABLED', #lrtm

        [ValidateSet('YES', 'NO')]
        [string]$Secure = 'NO', #secure

        [ValidateSet('YES', 'NO')]
        [string]$IPTunnel = 'NO', #iptunnel

        [string]$ScriptName, #scriptname

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$DispatcherIP, #dispatcherip 

        [int]$DispatcherPort, #dispatcherport

        [string]$ScriptArgs, #scriptargs

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Server')) {
                $m = New-Object com.citrix.netscaler.nitro.resource.config.lb.lbmonitor
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
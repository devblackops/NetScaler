function New-NSLBServer {
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
        [int]$ResponseTimeoutType = 'SEC', #units4

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
        [int]$NSMPAlertRetries, #alertretries

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

        [string]$ScriptArgs #scriptargs
    )

    begin {
        _AssertSessionActive
    }

    process {

        # com.citrix.netscaler.nitro.resource.config.lb.lbmonitor


        foreach ($item in $Name) {



        }
    }
}
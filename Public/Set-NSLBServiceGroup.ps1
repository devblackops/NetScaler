function Set-NSLBServiceGroup {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [Alias('ServiceGroupName')]
        [string[]]$Name,

        [ValidateSet('NO', 'YES')]
        [string]$Cacheable = 'NO',

        [ValidateSet('NO', 'YES')]
        [string]$HealthMonitor = 'YES',

        [ValidateSet('DISABLED', 'ENABLED')]
        [string]$AppFlowLog = 'ENABLED',

        [string]$Comment,

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
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Service Group')) {
                $sg = New-Object com.citrix.netscaler.nitro.resource.config.basic.servicegroup
                $sg.servicegroupname = $item
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
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $sg.comment = $Comment
                }
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

                $result = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup]::update($session, $sg)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServiceGroup -Name $item
                }
            }
        }
    }
}
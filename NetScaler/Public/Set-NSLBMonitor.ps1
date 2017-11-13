<#
Copyright 2017 Juan C. Herrera

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

function Set-NSLBMonitor {
    <#
    .SYNOPSIS
        Modifies a load balancer server monitor.

    .DESCRIPTION
        Modifies a load balancer server monitor.

    .EXAMPLE
        Set-NSLBMonitor -Name 'mysite_mon' -Interval 3 -IntervalType MIN -DestinationIP 10.11.12.13 -DestinationPort 80

        Modifies an existing load balancing monitor with IP address 10.11.12.13 using port 80 every 3 minutes.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the monitor.
        Must begin with an ASCII alphanumeric or underscore (_) character, and must contain
        only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@),
        equals (=), and hyphen (-) characters.

        Minimum length = 1

    .PARAMETER Type
        Type of monitor that you want to create.

        Possible values = PING, TCP, HTTP, TCP-ECV, HTTP-ECV, UDP-ECV, DNS, FTP, LDNS-PING,
        LDNS-TCP, LDNS-DNS, RADIUS, USER, HTTP-INLINE, SIP-UDP, LOAD, FTP-EXTENDED, SMTP,
        SNMP, NNTP, MYSQL, MYSQL-ECV, MSSQL-ECV, ORACLE-ECV, LDAP, POP3, CITRIX-XML-SERVICE,
        CITRIX-WEB-INTERFACE, DNS-TCP, RTSP, ARP, CITRIX-AG, CITRIX-AAC-LOGINPAGE, CITRIX-AAC-LAS,
        CITRIX-XD-DDC, ND6, CITRIX-WI-EXTENDED, DIAMETER, RADIUS_ACCOUNTING, STOREFRONT, APPC,
        CITRIX-XNC-ECV, CITRIX-XDM

    .PARAMETER Interval
        Time interval between two successive probes. Must be greater than the value of Response Time-out.

        Default value: 5
        Minimum value = 1
        Maximum value = 20940000

    .PARAMETER IntervalType
        Monitor interval units.

        Default value: SEC
        Possible values = SEC, MSEC, MIN

    .PARAMETER DestinationIP
        IP address of the service to which to send probes.
        If the parameter is set to 0, the IP address of the server to which the monitor is bound is
        considered the destination IP address.

    .PARAMETER DestinationPort
        TCP or UDP port to which to send the probe.
        If the parameter is set to 0, the port number of the service to which the monitor is bound is
        considered the destination port. For a monitor of type USER, however, the destination port is
        the port number that is included in the HTTP request sent to the dispatcher. Does not apply to
        monitors of type PING.

    .PARAMETER ResponseTimeout
        Amount of time for which the appliance must wait before it marks a probe as FAILED.

    .PARAMETER ResponseTimeoutType
        Amount of time for which the appliance must wait before it marks a probe as FAILED.
        Must be less than the value specified for the Interval parameter.

        Note: For UDP-ECV monitors for which a receive string is not configured, response timeout
        does not apply. For UDP-ECV monitors with no receive string, probe failure is indicated by
        an ICMP port unreachable error received from the service.

        Default value: 2
        Minimum value = 1
        Maximum value = 20939000

    .PARAMETER Downtime
        Time duration for which to wait before probing a service that has been marked as DOWN.

    .PARAMETER DowntimeType
        Time duration for which to wait before probing a service that has been marked as DOWN.
        Expressed in milliseconds, seconds, or minutes.

        Default value: 30
        Minimum value = 1
        Maximum value = 20939000

    .PARAMETER Deviation
        Time value added to the learned average response time in dynamic response time monitoring (DRTM).
        When a deviation is specified, the appliance learns the average response time of bound services
        and adds the deviation to the average. The final value is then continually adjusted to accommodate
        response time variations over time. Specified in milliseconds, seconds, or minutes.

        Minimum value = 0
        Maximum value = 20939000

    .PARAMETER Retries
        Maximum number of probes to send to establish the state of a service for which a monitoring probe failed.

        Default value: 3
        Minimum value = 1
        Maximum value = 127

    .PARAMETER ResponseTimeoutThreshold
        Response time threshold, specified as a percentage of the Response Time-out parameter.
        If the response to a monitor probe has not arrived when the threshold is reached, the appliance generates
        an SNMP trap called monRespTimeoutAboveThresh. After the response time returns to a value below the threshold,
        the appliance generates a monRespTimeoutBelowThresh SNMP trap. For the traps to be generated,
        the "MONITOR-RTO-THRESHOLD" alarm must also be enabled.

        Minimum value = 0
        Maximum value = 100

    .PARAMETER AlertRetries
        Number of consecutive probe failures after which the appliance generates an SNMP trap called monProbeFailed.

        Minimum value = 0
        Maximum value = 32

    .PARAMETER SuccessRetries
        Number of consecutive successful probes required to transition a service's state from DOWN to UP.

        Default value: 1
        Minimum value = 1
        Maximum value = 32

    .PARAMETER FailureRetries
        Number of retries that must fail, out of the number specified for the Retries parameter, for a service to be marked as DOWN.
        For example, if the Retries parameter is set to 10 and the Failure Retries parameter is set to 6, out of the ten probes
        sent, at least six probes must fail if the service is to be marked as DOWN. The default value of 0 means that all the retries
        must fail if the service is to be marked as DOWN.

        Minimum value = 0
        Maximum value = 32

    .PARAMETER NetProfile
        Name of the network profile.

        Minimum length = 1
        Maximum length = 127

    .PARAMETER TOS
        Probe the service by encoding the destination IP address in the IP TOS (6) bits.

        Possible values = YES, NO

    .PARAMETER TOSID
        The TOS ID of the specified destination IP.
        Applicable only when the TOS parameter is set.

        Minimum value = 1
        Maximum value = 63

    .PARAMETER State
        State of the monitor.
        The DISABLED setting disables not only the monitor being configured, but all monitors of the same type, until the parameter
        is set to ENABLED. If the monitor is bound to a service, the state of the monitor is not taken into account when the state
        of the service is determined.

        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER Reverse
        Mark a service as DOWN, instead of UP, when probe criteria are satisfied, and as UP instead of DOWN when probe criteria are
        not satisfied.

        Default value: NO
        Possible values = YES, NO

    .PARAMETER Transparent
        The monitor is bound to a transparent device such as a firewall or router.
        The state of a transparent device depends on the responsiveness of the services behind it. If a transparent device is being
        monitored, a destination IP address must be specified. The probe is sent to the specified IP address by using the MAC address
        of the transparent device.

        Default value: NO
        Possible values = YES, NO

    .PARAMETER LRTM
        Calculate the least response times for bound services.
        If this parameter is not enabled, the appliance does not learn the response times of the bound services. Also used for LRTM
        load balancing.

        Possible values = ENABLED, DISABLED

    .PARAMETER Secure
        Use a secure SSL connection when monitoring a service.
        Applicable only to TCP based monitors. The secure option cannot be used with a CITRIX-AG monitor, because a CITRIX-AG monitor
        uses a secure connection by default.

        Default value: NO
        Possible values = YES, NO

    .PARAMETER IPTunnel
        Send the monitoring probe to the service through an IP tunnel. A destination IP address must be specified.

        Default value: NO
        Possible values = YES, NO

    .PARAMETER ScriptName
        Path and name of the script to execute.
        The script must be available on the NetScaler appliance, in the /nsconfig/monitors/ directory.

        Minimum length = 1

    .PARAMETER DispatcherIP
        IP address of the dispatcher to which to send the probe.

    .PARAMETER DispatcherPort
        IP address of the dispatcher to which to send the probe.

    .PARAMETER ScriptArgs
        String of arguments for the script. The string is copied verbatim into the request.

    .PARAMETER CustomProperty
        Send additional monitor-specific properties when creating the monitor.

        Example STOREFRONT monitor value: @{ StoreName = 'Store' }

    .PARAMETER ResponseCode
        Response codes for which to mark the service as UP

    .PARAMETER HTTPRequest
        HTTP request to send to the server (for example, "HEAD /file.html").

    .PARAMETER Passthru
        Return the load balancer monitor object.

    .PARAMETER Send
        String to send to the service. Applicable to TCP-ECV, HTTP-ECV, and UDP-ECV monitors.

    .PARAMETER Recv
        String expected from the server for the service to be marked as UP. Applicable to TCP-ECV, HTTP-ECV, and UDP-ECV monitors.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

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

        [int]$DestinationPort,

        [ValidateRange(1, 20939000)]
        [int]$ResponseTimeout = 2,

        [ValidateSet('SEC', 'MSEC', 'MIN')]
        [string]$ResponseTimeoutType = 'SEC',

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
        [string]$State = 'ENABLED',

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

        [System.Collections.Hashtable]$CustomProperty,

        [switch]$PassThru,

        [Parameter()]
        [string[]]
        $ResponseCode,

        [Parameter()]
        [string]
        $HTTPRequest,

        [Parameter()]
        [string]
        $Send,

        [Parameter()]
        [string]
        $Recv
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Update Monitor')) {
                try {
                    $existingMonitor = Get-NSLBMonitor -Name $item
                    $params = @{
                        monitorname = $item
                        type = $existingMonitor.type
                        interval = $Interval
                        units3 = $IntervalType
                        units4 = $ResponseTimeoutType
                        downtime = $Downtime
                        units2 = $DowntimeType
                        retries = $Retries
                        resptimeout = $ResponseTimeout
                        successretries = $SuccessRetries
                        tos = $TOS
                        state = $State
                        reverse = $Reverse
                        transparent = $Transparent
                        lrtm = $LRTM
                        secure = $Secure
                        iptunnel = $IPTunnel
                    }
                    if ($PSBoundParameters.ContainsKey('DestinationIP')) {
                        $params.Add('destip', $DestinationIP)
                    }
                    if ($PSBoundParameters.ContainsKey('DestinationPort')) {
                        $params.Add('destport', $DestinationPort)
                    }
                    if ($PSBoundParameters.ContainsKey('Deviation')) {
                        $params.Add('deviation', $Deviation)
                    }
                    if ($PSBoundParameters.ContainsKey('ResponseTimeoutThreshold')) {
                        $params.Add('resptimeoutthresh', $ResponseTimeoutThreshold)
                    }
                    if ($PSBoundParameters.ContainsKey('AlertRetries')) {
                        $params.Add('alertretries', $AlertRetries)
                    }
                    if ($PSBoundParameters.ContainsKey('FailureRetries')) {
                        $params.Add('failureretries', $FailureRetries)
                    }
                    if ($PSBoundParameters.ContainsKey('NetProfile')) {
                        $params.Add('netprofile', $NetProfile)
                    }
                    if ($PSBoundParameters.ContainsKey('TOSID')) {
                        $params.Add('tosid', $TOSID)
                    }
                    if ($PSBoundParameters.ContainsKey('ScriptName')) {
                        $params.Add('scriptname', $ScriptName)
                    }
                    if ($PSBoundParameters.ContainsKey('DispatcherIP')) {
                        $params.Add('dispatcherip', $DispatcherIP)
                    }
                    if ($PSBoundParameters.ContainsKey('ScriptArgs')) {
                        $params.Add('scriptargs', $ScriptArgs)
                    }
                    if ($PSBoundParameters.ContainsKey('CustomProperty')) {
                        ## Add each custom property to the $params Hashtable
                        foreach ($key in $CustomProperty.Keys) {
                            $params.Add($key.ToLower(), $CustomProperty[$key])
                        }
                    }
                    if ($PSBoundParameters.ContainsKey('ResponseCode')) {
                        $params.Add('respcode', $ResponseCode)
                    }
                    if ($PSBoundParameters.ContainsKey('HTTPRequest')) {
                        $params.Add('httprequest', $HTTPRequest)
                    }
                    if ($PSBoundParameters.ContainsKey('Send')) {
                        $params.Add('send', $Send)
                    }
                    if ($PSBoundParameters.ContainsKey('Recv')) {
                        $params.Add('recv', $Recv)
                    }
                    _InvokeNSRestApi -Session $Session -Method PUT -Type lbmonitor -Payload $params

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBMonitor -Session $session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
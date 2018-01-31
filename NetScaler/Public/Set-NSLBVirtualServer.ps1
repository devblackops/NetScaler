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

function Set-NSLBVirtualServer {
    <#
    .SYNOPSIS
        Updates an existing load balancer virtual server.

    .DESCRIPTION
        Updates an existing load balancer virtual server.

    .EXAMPLE
        Set-NSLBVirtualServer -Name 'vserver01' -LBMethod 'ROUNDROBIN'

        Sets the load balancing method for virtual server 'vserver01' to 'ROUNDROBIN'.

    .EXAMPLE
        Set-NSLBVirtualServer -Name 'vserver01' -Comment 'this is a comment' -PassThru

        Sets the comment for virtual server 'vserver01' and returns the updated object.

    .EXAMPLE
        Set-NSLBVirtualServer -Name 'vserver01' -IPAddress '11.11.11.11' -HttpRedirectURL "http://google.com" -Force

        Sets the IP address for virtual server 'vserver01' to '11.11.11.11' with a redirect to Google.com in case the backend services/service group are not available and suppresses confirmation.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to set.

    .PARAMETER PersistenceType
        The type of persistence for the virtual server. Possible values = SOURCEIP, COOKIEINSERT, SSLSESSION, RULE, URLPASSIVE, CUSTOMSERVERID, DESTIP, SRCIPDESTIP, CALLID, RTSPSID, DIAMETER, NONE

    .PARAMETER LBMethod
        The load balancing method of the virtual server.

    .PARAMETER IPAddress
        The IP Address of the virtual server.

    .PARAMETER Comment
        The comment associated with the virtual server.

    .PARAMETER HttpRedirectURL
        The URL to which to redirect traffic if the virtual server becomes unavailable.

    .PARAMETER ICMPVSRResponse
        The URL to which to redirect traffic if the virtual server becomes unavailable. The dfault value is "Passive"

    .PARAMETER TimeOut
        The time period for which a persistence session is in effect. The default value is 2 seconds.

    .PARAMETER ClientTimeout
        Idle time, in seconds, after which a client connection is terminated.
        Minimum value = 0
        Maximum value = 31536000

    .PARAMETER BackupVServer
        Name of the backup virtual server to which to forward requests if the primary virtual server goes DOWN or reaches its spillover threshold.
        Minimum length = 1

    .PARAMETER RedirectPortRewrite
        Rewrite the port and change the protocol to ensure successful HTTP redirects from services.
        Default value: DISABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER Force
        Suppress confirmation when updating a virtual server.

    .PARAMETER Passthru
        Return the virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [ValidateSet('ROUNDROBIN', 'LEASTCONNECTION', 'LEASTRESPONSETIME', 'LEASTBANDWIDTH', 'LEASTPACKETS', 'CUSTOMLOAD', 'LRTM', 'URLHASH', 'DOMAINHASH', 'DESTINATIONIPHASH', 'SOURCEIPHASH', 'TOKEN', 'SRCIPDESTIPHASH', 'SRCIPSRCPORTHASH', 'CALLIDHASH')]
        [string]$LBMethod,

        [ValidateSet('SOURCEIP', 'COOKIEINSERT', 'SSLSESSION', 'CUSTOMSERVERID', 'RULE', 'URLPASSIVE', 'DESTIP', 'SRCIPDESTIP', 'CALLID' ,'RTSPID', 'FIXSESSION', 'NONE')]
        [string]
        $PersistenceType,

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [string]$HttpRedirectURL,

        [ValidateLength(0, 256)]
        [string]$Comment,

        [ValidateSet('PASSIVE', 'ACTIVE')]
        [string]$ICMPVSRResponse,

        [int]$TimeOut,

        [int]$ClientTimeout,

        [string]$BackupVServer,

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$RedirectPortRewrite,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Virtual Server')) {
                $params = @{
                    name = $item
                }
                if ($PSBoundParameters.ContainsKey('TimeOut')) {
                    $params.Add('timeout', $TimeOut)
                }
                if ($PSBoundParameters.ContainsKey('ICMPVSRResponse')) {
                    $params.Add('icmpvsrresponse', $ICMPVSRResponse)
                }
                if ($PSBoundParameters.ContainsKey('LBMethod')) {
                    $params.Add('lbmethod', $LBMethod)
                }
                if ($PSBoundParameters.ContainsKey('PersistenceType')) {
                    $params.Add('persistencetype', $PersistenceType)
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $params.Add('comment', $Comment)
                }
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $params.Add('ipv46', $IPAddress)
                }
                if ($PSBoundParameters.ContainsKey('HttpRedirectURL')) {
                    $params.Add('redirurl', $HttpRedirectURL)
                }
                if ($PSBoundParameters.ContainsKey('ClientTimeout')) {
                    $params.Add('clttimeout', $ClientTimeout)
                }
                if ($PSBoundParameters.ContainsKey('BackupVServer')) {
                    $params.Add('backupvserver', $BackupVServer)
                }
                if ($PSBoundParameters.ContainsKey('RedirectPortRewrite')) {
                    $params.Add('RedirectPortRewrite', $RedirectPortRewrite)
                }
                _InvokeNSRestApi -Session $Session -Method PUT -Type lbvserver -Payload $params #-Action update

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Session $Session -Name $item
                }
            }
        }
    }
}
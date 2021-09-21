<#
Copyright 2016 Dominique Broeglin

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

function New-NSNTPServer {
    <#
    .SYNOPSIS
        Creates a new NTP  server.

    .DESCRIPTION
        Creates a new NTP server.

    .EXAMPLE
        New-NSNTPServer -Server 1.2.3.4

        Create a new KCD account with the given delegate user.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Server
        IP address (or array of addresses) of the NTP server(s).

    .PARAMETER MinPollInterval
        Minimum poll interval: minimum time after which Netscaler must poll the NTP server.
        Expressed power of 2 seconds.

        Default value: 6 (64 seconds)

    .PARAMETER MaxPollInterval
        Maximum poll interval: maximum time after which Netscaler must poll the NTP server.
        Expressed power of 2 seconds.

        Default value: 10 (1024 seconds)

    .PARAMETER Passthru
        Return the load balancer server object.

    .NOTES
        Nitro implementation status: partial

    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:Session,

        [parameter(Mandatory = $true)]
        [String[]]$Server,

        [Int]$MinPollInterval = 6,

        [Int]$MaxPollInterval = 10,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Server) {
            if ($PSCmdlet.ShouldProcess($item, 'Create NTP server')) {
                try {
                    $params = @{
                        serverip = $item
                        minpoll  = $MinPollInterval
                        maxpoll  = $MaxPollInterval
                        autokey  = 'false'
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type ntpserver -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return (Get-NTPServer -Session $session -Name $item)
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
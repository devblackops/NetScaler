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

function Remove-NSNTPServer {
    <#
    .SYNOPSIS
        Removes an existing NTP server setting.

    .DESCRIPTION
        Removes an existing NTP server.

    .EXAMPLE
        Remove-NSNTPServer -Server 1.2.3.4

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Server
        IP address (or array of addresses) of the NTP server(s).

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

        [parameter(Mandatory = $true)]
        [String[]]$ServerIP,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        $params =@{
            servername = $server
        }        
        foreach ($item in $ServerIP) {
            if ($PSCmdlet.ShouldProcess($item, 'Remove NTP server')) {
                try {

                    _InvokeNSRestApi -Session $Session -Method DELETE -Type ntpserver -Resource $item -Arguments $params -Action delete

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

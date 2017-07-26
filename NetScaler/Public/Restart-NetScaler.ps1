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

function Restart-NetScaler {
    <#
    .SYNOPSIS
        Restart NetScaler appliance, with an option to save NetScaler config file before rebooting.

    .DESCRIPTION
        Restart NetScaler appliance, with an option to save NetScaler config file before rebooting.

    .EXAMPLE
        Restart-NetScaler

        Restart a NetScaler appliance.

    .EXAMPLE
        Restart-NetScaler -Session $session -Force

        Restart NetScaler and suppress confirmation.

    .EXAMPLE
        Restart-NetScaler -Session $session -SaveConfig

        Save config on NetScaler then reboot.

    .EXAMPLE
        Restart-NetScaler -Session $session -WarmReboot

        Perform a warm reboot of the NetScaler.

    .EXAMPLE
        Restart-NetScaler -Wait -WaitTimeout 180

        Restart NetScaler then wait for it to become available again. Stop waiting after 180 seconds.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER SaveConfig
        Save NetScaler config file before rebooting.

    .PARAMETER WarmReboot
        Perform a warm reboot of the NetScaler appliance.

    .PARAMETER Wait
        Wait for Nitro REST API is become online after reboot.

    .PARAMETER WaitTimeout
        Timeout in seconds for the wait after reboot.

    .PARAMETER Force
        Suppress confirmation when rebooting NetScaler.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [switch]$SaveConfig,

        [switch]$WarmReboot,

        [switch]$Wait,

        [int]$WaitTimeout = 900,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        $ip = $($Session.EndPoint)
        if ($Force -or $PSCmdlet.ShouldProcess($ip, 'Reboot NetScaler appliance')) {

            if ($PSBoundParameters.ContainsKey('SaveConfig')) {
                Save-NSConfig -Session $Session
            }

            $params = @{
                warm=$WarmReboot.ToBool() 
            }
            _InvokeNSRestApi -Session $Session -Method POST -Type reboot -Payload $params -Action reboot

            $canWait = $true
            $ping = New-Object -TypeName System.Net.NetworkInformation.Ping
            if ($PSBoundParameters.ContainsKey('Wait')) {
                $waitStart = Get-Date
                Write-Verbose -Message 'Trying to ping until unreachable to ensure reboot process'
                while ($canWait -and $($ping.Send($ip, 2000)).Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
                    if ($($(Get-Date) - $waitStart).TotalSeconds -gt $WaitTimeout) {
                        $canWait = $false
                        break
                    } else {
                        Write-Verbose -Message 'Still reachable. Pinging again...'
                        Start-Sleep -Seconds 2
                    }
                } 

                if ($canWait) {
                    Write-Verbose -Message 'Trying to reach Nitro REST API to test connectivity...'
                    while ($canWait) {
                        $connectTestError = $null
                        $response = $null
                        try {
                            $params = @{
                                Uri = $Session.CreateUri("config")
                                Method = 'GET'
                                ContentType = 'application/json'
                                ErrorVariable = 'connectTestError'
                            }
                            $response = Invoke-RestMethod @params
                        }
                        catch {
                            if ($connectTestError) {
                                if ($connectTestError.InnerException.Message -eq 'The remote server returned an error: (401) Unauthorized.') {
                                    break
                                } elseif ($($(Get-Date) - $waitStart).TotalSeconds -gt $WaitTimeout) {
                                    $canWait = $false
                                    break
                                } else {
                                    Write-Verbose -Message 'Nitro REST API is not responding. Trying again...'
                                    Start-Sleep -Seconds 2
                                }
                            }
                        }
                        if ($response) {
                            break
                        }
                    }
                }

                if ($canWait) {
                    Write-Verbose -Message 'NetScaler appliance is back online.'
                } else {
                    throw 'Timeout expired. Unable to determine if NetScaler appliance is back online.'
                }
            }
        }
    }
}
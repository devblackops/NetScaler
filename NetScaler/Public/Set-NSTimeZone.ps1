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

Set-Variable -Name NSTimeZones -Value $(Get-NSAvailableTimeZone) -Option Constant

function Set-NSTimeZone {
    <#
    .SYNOPSIS
        Set NetScaler timezone

    .DESCRIPTION
        Set NetScaler timezone

    .EXAMPLE
        Set-NSTimeZone -Session $session -TimeZone 'GMT-07:00-PDT-America/Los_Angeles'

        Configures the NetScaler appliance timezone to 'America/Los_Angeles'.

    .EXAMPLE
        $tz = Get-NSAvailableTimeZone | Where-Object {$_ -match 'Paris'} | Select-Object -First 1
        Set-NSTimeZone -HostName 'mynsappliance' -TimeZone $tz

        Configures the NetScaler appliance timezone to and available timezone that has 'Paris' in its name.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Timezone
        The timezone to set the appliance to.

    .PARAMETER Force
        Suppress confirmation when updating the timezone.

    .PARAMETER Passthru
        Return the hostname.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='high')]
    param(
        [parameter(Mandatory)]
        $Session = $script:session,

        [parameter(Mandatory)]
        [ValidateScript({
            if ($NSTimeZones -contains $_) {
                $true
            } else {
                throw "Valid values are: $($NSTimeZones -join ', ')"
            }
        })]
        [string]$TimeZone,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        $ip = $($Session.Endpoint)
        if ($Force -or $PSCmdlet.ShouldProcess($ip, "Set timezone of NS appliance to: $TimeZone")) {
            $params = @{
                timezone = $TimeZone
            }
            _InvokeNSRestApi -Session $Session -Method PUT -Type nsconfig -Payload $params

            if ($PSBoundParameters.ContainsKey('PassThru')) {
                $config = _InvokeNSRestApi -Session $Session -Method GET -Type nsconfig -Action get
                return $config.nsconfig
            }
        }
    }
}
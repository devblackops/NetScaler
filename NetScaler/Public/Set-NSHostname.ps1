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

function Set-NSHostname {
    <#
    .SYNOPSIS
        Set NetScaler hostname

    .DESCRIPTION
        Set NetScaler hostname

    .EXAMPLE
        Set-NSHostname -Session $session -Hostname 'mynsappliance'

        Changes the NetScaler hostname to 'mynsappliance'

    .EXAMPLE
        Set-NSHostname -Hostname 'mynsappliance'

        Changes the NetScaler hostname to 'mynsappliance'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Hostname
        The hostname to set the appliance to.

    .PARAMETER Force
        Suppress confirmation when updating the hostname.

    .PARAMETER Passthru
        Return the hostname.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='high')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [ValidateLength(1, 255)]
        [string]$Hostname = (Read-Host -Prompt 'NetScaler hostname'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        $ip = $($Session.Endpoint)
        if ($Force -or $PSCmdlet.ShouldProcess($ip, "Set hostname of NS appliance to: $Hostname")) {
            $params = @{
                hostname = $Hostname
            }
            _InvokeNSRestApi -Session $Session -Method PUT -Type nshostname -Payload $params

            if ($PSBoundParameters.ContainsKey('PassThru')) {
                return _InvokeNSRestApi -Session $Session -Method GET -Type nshostname -Action get
            }
        }
    }
}
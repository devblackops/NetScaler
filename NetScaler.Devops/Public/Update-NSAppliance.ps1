<#
Copyright 2017 Ryan Butler

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

function Update-NSAppliance {
    <#
    .SYNOPSIS
        Updates a Netscaler and uses firmware from a remote location.
    .DESCRIPTION
        Updates a Netscaler and uses firmware from a remote location.
    .PARAMETER Session
        An existing custom NetScaler Web Request Session object returned by Connect-NSAppliance
    .PARAMETER Url
        URL for Netscaler firmware (MANDATORY)
    .PARAMETER NoReboot
        Don't reboot after upgrade
    .PARAMETER NoCallhome
        Don't enable CallHome
    .EXAMPLE
        Update-NSAppliance -Session $Session -url "https://mywebserver/build-11.1-47.14_nc.tgz"
    .NOTES
        Author: Ryan Butler - @ryan_c_butler
        Date Created: 09-07-2017
        Will probably fail with VPX Express due to API timeout
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url,

        $Session = $Script:Session,

        [switch]$NoReboot,

        [switch]$NoCallhome
    )

    begin {
        _AssertSessionActive
    }

    process {
        if (-not $nocallhome) {
            Write-Verbose -Message 'Enabling callhome'
            $ch = $true
        } else {
            Write-Verbose -Message 'Disabling callhome'
            $ch = $false
        }

        if (-not $NoReboot) {
            Write-Verbose -Message 'Rebooting NS Appliance'
            $reboot = $true
        } else {
            Write-Verbose -Message 'Skipping reboot'
            $reboot = $false
        }

        # Build upgrade payload
        $payload = @{
            'url' = $Url
            'y' = $reboot
            'l' = $ch
        }

        # Attempt upgrade
        try {
            _InvokeNSRestApi -Session $Session -Method POST -Type install -Payload $payload
        } catch{
            throw $_
        }
    }
}

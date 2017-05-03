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

function Remove-NSDnsNameServer {
    <#
    .SYNOPSIS
        Remove a domain name server from NetScaler appliance.

    .DESCRIPTION
        Remove a domain name server from NetScaler appliance.

    .EXAMPLE
        Remove-NSDnsNameServer -IPAddress '8.8.8.8'

        Remove DNS server IP 8.8.8.8 from NetScaler.

    .EXAMPLE
        '2.2.2.2', '8.8.8.8' | Remove-NSDnsNameServer -Session $session

        Removes DNS servers with IPs 2.2.2.2 and 8.8.8.8 from NetScaler using the pipeline.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER IPAddress
        IP address of an external name server or, if the Local parameter is set, IP address of a local DNS server (LDNS).

    .PARAMETER Force
        Suppress confirmation adding certificate binding
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter()]
        # [ValidateScript({$_ -match [IPAddress]$_ })]
        [string[]]$IPAddress = (Read-Host -Prompt 'DNS server IP'),

        [Switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $IPAddress) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Remove DNS server IP')) {
                try {

                    _InvokeNSRestApi -Session $Session -Method DELETE -Type dnsnameserver -Resource $item -Action delete

                } catch {
                    throw $_
                }
            }
        }
    }
}

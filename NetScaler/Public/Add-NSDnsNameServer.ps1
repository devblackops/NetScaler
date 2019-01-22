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

function Add-NSDnsNameServer {
    <#
    .SYNOPSIS
        Add domain name server to NetScaler appliance.

    .DESCRIPTION
        Add domain name server to NetScaler appliance.

    .EXAMPLE
        Add-NSDnsNameServer -DNSServerIP '8.8.8.8'

        Adds DNS server IP 8.8.8.8 to NetScaler.

    .EXAMPLE
        '2.2.2.2', '8.8.8.8' | Add-NSDnsNameServer -Session $session

        Adds DNS server IP 8.8.8.8 to NetScaler using the pipeline.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER IPAddress
        IP address of an external name server or, if the Local parameter is set, IP address of a local DNS server (LDNS).

    .PARAMETER DNSVServerName
        Name of a DNS virtual server. Overrides any IP address-based name servers configured on the NetScaler appliance.

    .PARAMETER Local
        Mark the IP address as one that belongs to a local recursive DNS server on the NetScaler appliance.
        The appliance recursively resolves queries received on an IP address that is marked as being local.
        For recursive resolution to work, the global DNS parameter, Recursion, must also be set.
        If no name server is marked as being local, the appliance functions as a stub resolver and load balances the name servers.

    .PARAMETER State
        Administrative state of the name server.

        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER Type
        Protocol used by the name server. UDP_TCP is not valid if the name server is a DNS virtual server configured on the appliance.

        Default value: UDP
        Possible values = UDP, TCP, UDP_TCP

    .PARAMETER Passthru
        Return the load balancer server object.

    .PARAMETER Force
        Suppress confirmation adding certificate binding
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string[]]$IPAddress = (Read-Host -Prompt 'DNS server IP'),

        [string]$DNSVServerName = [string]::Empty,

        [switch]$Local = $false,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$State = 'ENABLED',

        [ValidateSet('UDP', 'TCP', 'UDP_TCP')]
        [string]$Type = 'UDP'
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $IPAddress) {
            if ($PSCmdlet.ShouldProcess($item, 'Add DNS server IP')) {
                try {

                    $params = @{
                        ip = $IPAddress
                        local = $Local.ToBool()
                        state = $State
                        type = $Type
                    }
                    if ($PSBoundParameters.ContainsKey('DNSVServerName')) {
                        $params.Add('dnsvservername', $DNSVServerName)
                    }

                    _InvokeNSRestApi -Session $Session -Method POST -Type dnsnameserver -Payload $params -Action add | Out-Null
                } catch {
                    throw $_
                }
            }
        }
    }
}
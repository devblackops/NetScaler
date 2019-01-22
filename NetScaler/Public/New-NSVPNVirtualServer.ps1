<#
Copyright 2016 Iain Brighton

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

function New-NSVPNVirtualServer {
    <#
    .SYNOPSIS
        Creates a new NetScaler Gateway virtual server.

    .DESCRIPTION
        Creates a new NetScaler Gateway virtual server.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the NetScaler Gateway virtual server. Must begin with an ASCII alphanumeric or underscore (_) character,
        and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@),
        equal sign (=), and hyphen (-) characters. Can be changed after the virtual server is created.

        Minimum length = 1

    .PARAMETER IPAddress
        IPv4 or IPv6 address to assign to the NetScaler Gateway virtual server.

        Default value: DISABLED

    .PARAMETER Comment
        Any comments that you might want to associate with the NetScaler Gateway virtual server.

    .PARAMETER Port
        Port number for the virtual server.

        Range 1 - 65535

    .PARAMETER Authentication
        Require authentication for users connecting to NetScaler Gateway virtual server.

        Default value: ENABLED

    .PARAMETER ICAOnly
        User can log on in Basic mode only, through either Citrix Receiver or a browser. Users are not allowed to connect by using the NetScaler Gateway Plug-in.

        Default value: OFF
    
    .PARAMETER RDPServerProfileName
        Name of the RDP server profile associated with the vserver.
        
        Minimum length = 1
        Maximum length = 31

    .EXAMPLE
        New-NSVPNVirtualServer -Name 'ag01' -IPAddress '192.168.0.100'

        Creates a new NetScaler Gateway virtual server named 'ag01'.

    .PARAMETER Passthru
        Return the NetScaler Gaetway server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$Name,

        [parameter()]
        [string]$IPAddress,

        [ValidateRange(1,65535)]
        [int]$Port=443,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$Authentication,

        [switch]$ICAOnly,

        [ValidateLength(0, 256)]
        [string]$Comment,

        [ValidateLength(1, 31)]
        [string]$RDPServerProfileName,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create NetScaler Gateway Virtual Server')) {
            try {
                $params = @{
                    name = $Name
                    servicetype = 'SSL'
                    port = $Port
                }
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $params.Add('ipv46', $IPAddress)
                }
                if ($PSBoundParameters.ContainsKey('Authentication')) {
                    $params.Add('authentication', $Authentication)
                }
                if ($PSBoundParameters.ContainsKey('ICAOnly')) {
                    $ica = if ($ICAOnly) { 'ON' } else { 'OFF' }
                    $params.Add('icaonly', $ica)
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $params.Add('comment', $Comment)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type vpnvserver -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSVPNVirtualServer -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

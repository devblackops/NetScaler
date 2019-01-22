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

function Set-NSVPNVirtualServerTheme {
    <#
    .SYNOPSIS
        Configures an existing NetScaler virtual server theme.

    .DESCRIPTION
        Configures an existing NetScaler virtual server theme.

    .EXAMPLE
        Set-NSVPNVirtualServerTheme -Name 'ag01' -Theme 'X1'

        Sets the'ag01' NetScaler Gateway virtual server's theme to the built-in 'X1' theme.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the NetScaler Gateway virtual servers to set.

    .PARAMETER Theme
        The name of the theme to apply to the NetScaler Gateway virtual server.

    .PARAMETER Force
        Suppress confirmation when updating a virtual server.

    .PARAMETER Passthru
        Return the virtual server object.

    .NOTES
        Requires NetScaler 11.0 or later
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [alias('VirtualServerName')]
        [string[]]$Name,

        [parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('Default', 'GreenBubble', 'X1', 'RfWebUI')]
        [string]$Theme,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
        _AssertNSVersion -MinimumVersion '11.0'
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit NetScaler Gateway Theme')) {
                try {
                    $params = @{
                        name = $item;
                        portaltheme = $Theme;
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type vpnvserver_vpnportaltheme_binding -Payload $params

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerTheme -Session $Session -Name $item
                    }
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

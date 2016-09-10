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

function Get-NSVPNVirtualServerTheme {
    <#
    .SYNOPSIS
        Configures an existing NetScaler virtual server theme.

    .DESCRIPTION
        Configures an existing NetScaler virtual server theme.

    .EXAMPLE
        Get-NSVPNVirtualServerTheme -Name 'ag01'

        Returns the NetScaler Gateway virtual server theme assigned to the 'ag01' virtual server.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the NetScaler Gateway virtual servers to set.

    .NOTES
        Requires NetScaler 11.0 or later
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [alias('VirtualServerName')]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        _AssertNSVersion -MinimumVersion '11.0'
    }

    process {
        try {
            if (-not $PSBoundParameters.ContainsKey('Name')) {
                $Name = Get-NSVPNVirtualServer | Select-Object -ExpandProperty Name
            }
            foreach ($item in $Name) {
                _InvokeNSRestApiGet -Session $Session -Type vpnvserver_vpnportaltheme_binding -Name $item
            }
        }
        catch {
            throw $_
        }
    }
}

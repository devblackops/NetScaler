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

function Add-NSVLANInterfaceBinding {
    <#
    .SYNOPSIS
        Binds a VLAN to an interface and tags/untags to NetScaler appliance.

    .DESCRIPTION
        Binds a VLAN to an interface and tags/untags to NetScaler appliance.

    .EXAMPLE
        Add-NSVLANInterfaceBinding -VLANID 150 -Interface '0/1' -Tagged

        Binds VLAN 150 to interface '0/1' and tags it on the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VLANID
        A positive integer that uniquely identifies a VLAN.

    .PARAMETER Interface
        The interface to be bound to the VLAN, specified in slot/port notation (for example, 1/3).     

    .PARAMETER Tagged
        Make the interface an 802.1q tagged interface.

    .PARAMETER Force
        Suppress confirmation when adding a DNS suffix.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$VLANID,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Interface,

        [parameter()]    
        [switch]$Tagged,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $VLANID) {
            if ($PSCmdlet.ShouldProcess($item, 'Add VLAN Binding')) {
                try {
                    $params = @{
                         id = $item
                         ifnum = $Interface
                         tagged = $Tagged.ToBool()
                    }
                    $response = _InvokeNSRestApi -Session $Session -Method PUT -Type vlan_interface_binding -Payload $params -Action add
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

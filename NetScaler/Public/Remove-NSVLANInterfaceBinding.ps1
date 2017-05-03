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

function Remove-NSVLANInterfaceBinding {
    <#
    .SYNOPSIS
        Deletes the binding of an interface as well as untagged/unbound from NetScaler appliance.

    .DESCRIPTION
        Deletes the binding of an interface as well as untagged/unbound from NetScaler appliance.

    .EXAMPLE
        Remove-NSVLANBinding -VLANID 150 -AliasName 'testvlan' -MTU 1500

        Adds VLAN 150 with an alias name of 'testvlan' and MTU of 1500 to the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VLANID
        A positive integer that uniquely identifies a VLAN.

    .PARAMETER Interface
        The interface to be bound to the VLAN, specified in slot/port notation (for example, 1/3).

    .PARAMETER Tagged
        Make the interface an 802.1q tagged interface.                 
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$VLANID,

        [parameter()]
        [string[]]$Interface,

        # [parameter()]    
        # [switch]$Tagged,        

        [Switch]$Force

    )

    begin {
        _AssertSessionActive
    }

    process {

        $params = @{
            ifnum = $Interface
            #tagged = $Tagged.ToBool()  not working - 
        }        
        foreach ($item in $VLANID) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Remove VLAN binding')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type vlan_interface_binding -Resource $item -Arguments $params -Action delete
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

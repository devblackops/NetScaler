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

function Remove-NSVLAN {
    <#
    .SYNOPSIS
        Removes an untagged/unbound VLAN from NetScaler appliance.

    .DESCRIPTION
        Removes an untagged/unbound VLAN from NetScaler appliance.

    .EXAMPLE
        Remove-NSVLAN -VLANID 150

        Removes VLAN 150 from the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VLANID
        A positive integer that uniquely identifies a VLAN.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline)]
        [string[]]$VLANID

    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $VLANID) {
            if ($PSCmdlet.ShouldProcess($item, 'Get VLAN information')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type vlan -Resource $item -Action delete
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

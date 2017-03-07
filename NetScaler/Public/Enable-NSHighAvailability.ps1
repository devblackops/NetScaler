<#
Copyright 2017 Dominique Broeglin

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

function Enable-NSHighAvailability {
    <#
    .SYNOPSIS
        Enable high-availability between two NetScaler instances.

    .DESCRIPTION
        Enable high-availability between two NetScaler instances.

    .EXAMPLE
        Enable-NSHighAvailability -PrimarySession $ns1 -SecondarySession Session $ns2

        Enable high-availability between the netscaler instances corresponding to 
        the already opened $ns1 and $ns2.

    .PARAMETER PrimarySession
        The NetScaler session object for the first NetScaler instance (will end up master).

    .PARAMETER SecondarySession
        The NetScaler session object for the second NetScaler instance (will end up slave).

    .PARAMETER PeerNodeId
        The node id used to denote the peer.

        Default value: 1

    .PARAMETER Force
        Suppress confirmation when activating high-availability.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        [parameter(Mandatory)]
        $PrimarySession,

        [parameter(Mandatory)]
        $SecondarySession,

        [int]$PeerNodeId = 1,

        [switch]$Force
    )

    begin {
        _AssertSessionActive -Session $PrimarySession
        _AssertSessionActive -Session $SecondarySession
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable high-availability')) {
            try {
                

            } catch {
                throw $_
            }
        }
    }
}
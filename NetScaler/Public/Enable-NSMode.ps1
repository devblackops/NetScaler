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

function Enable-NSMode {
    <#
    .SYNOPSIS
        Enable mode on NetScaler appliance.

    .DESCRIPTION
        Enable mode on NetScaler appliance.

    .EXAMPLE
        Enable-NSMode -Name 'l3'

        Enable the mode 'l3' on the NetScaler appliance.

    .EXAMPLE
        'fr', 'l3' | Enable-NSMode -Force
    
        Enable the modes 'fr' and 'l3' on the NetScaler appliance.    

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Mode to be enabled.
        
        Possible values = FR, FastRamp, L2, L2mode, L3, L3mode, USIP, UseSourceIP, CKA, ClientKeepAlive, 
        TCPB, TCPBuffering, MBF, MACbasedforwarding, Edge, USNIP, SRADV, DRADV, IRADV, SRADV6, DRADV6,
        PMTUD, RISE_APBR, RISE_RHI, BridgeBPDUs

    .PARAMETER Force
        Suppress confirmation when enabling the mode.

    .PARAMETER PassThru
        Return the status of the NetScaler modes.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [ValidateSet(
            'bridgebpbus', 'cka', 'dradv', 'dradv6', 'edge', 'fr', 'iradv', 'l2', 'l3', 'mbf',
            'pmtud', 'rise_apbr', 'rise_rhi', 'sradv', 'sradv6', 'tcpb', 'usip', 'usnip'
        )]
        [string[]]$Name = (Read-Host -Prompt 'Netscaler mode'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            try {
                $item = $item.ToLower()
                if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable NetScaler mode')) {
                    $params = @{
                        mode = $item
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type nsmode -Payload $params -Action enable

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSMode -Session $Session -Name $item
                    }
                }
            } catch {
                throw $_
            }
        }
    }
}
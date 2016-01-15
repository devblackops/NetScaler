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

function Enable-NSLBVirtualServer {
    <#
    .SYNOPSIS
        Enable load balancer virtual server object.

    .DESCRIPTION
        Enable load balancer virtual server object.

    .EXAMPLE
        Enable-NSLBVirtualServer -Name 'vserver01'

        Enable the load balancer virtual server 'vserver01'.

    .EXAMPLE
        'vserver01', 'vserver02' | Enable-NSLBVirtualServer -Force
    
        Enable the load balancer virtual servers 'vserver01' and 'vserver02' without confirmation.

    .EXAMPLE
        $vserver = Enable-NSLBVirtualServer -Name 'vserver01' -Force -PassThru

        Enable the load balancer virtual server 'vserver01' without confirmation and return the resulting object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the virtual server.

    .PARAMETER Force
        Suppress confirmation when enabling the virtual server.

    .PARAMETER PassThru
        Return the load balancer virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable Virtual Server')) {
                try {
                    $params = @{
                        name = $item
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type lbvserver -Payload $params -Action enable

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBVirtualServer -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
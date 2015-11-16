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

function Disable-NSLBVirtualServer {
    <#
    .SYNOPSIS
        Disable load balancer virtual server object.

    .DESCRIPTION
        Disable load balancer virtual server object.

    .EXAMPLE
        Disable-NSLBVirtualServer -Name 'vserver01'

        Disable the load balancer virtual server 'vserver01'.

    .EXAMPLE
        'vserver01', 'vserver02' | Disable-NSLBVirtualServer -Force
    
        Disable the load balancer virtual servers 'vserver01' and 'vserver02' without confirmation.

    .EXAMPLE
        $vserver = Disable-NSLBVirtualServer -Name 'vserver01' -Force -PassThru

        Disable the load balancer virtual server 'vserver01' without confirmation and return the resulting object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to disable.

    .PARAMETER Force
        Suppress confirmation when disabling the virtual server.

    .PARAMETER PassThru
        Return the load balancer virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

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
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Disable Virtual Server')) {
                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::disable($Session, $item)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Name $item
                }
            }
        }
    }
}
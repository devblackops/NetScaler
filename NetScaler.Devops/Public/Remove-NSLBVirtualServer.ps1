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

function Remove-NSLBVirtualServer {
    <#
    .SYNOPSIS
        Removes a load balancer virtual server.

    .DESCRIPTION
        Removes a load balancer virtual server.

    .EXAMPLE
        Remove-NSLBVirtualServer -Name 'vserver01'

        Removes the load balancer virtual server named 'vserver01'.

    .EXAMPLE
        'vserver01', 'vserver02' | Remove-NSLBVirtualServer
    
        Removes the load balancer virtual servers named 'vserver01' and 'vserver02'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to get.

    .PARAMETER Force
        Suppress confirmation when removing a load balancer virtual server.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Virtual Server')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type lbvserver -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
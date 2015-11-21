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

function Remove-NSLBMonitor {
    <#
    .SYNOPSIS
        Removes a load balancer monitor.

    .DESCRIPTION
        Removes a load balancer monitor.

    .EXAMPLE
        Remove-NSLBMonitor -Name 'monitor01'

        Removes the load balancer monitor named 'monitor01'.

    .EXAMPLE
        'monitor01', 'monitor02' | Remove-NSLBMonitor
    
        Removes the load balancer monitors named 'monitor01' and 'monitor02'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer monitor to get.

    .PARAMETER Force
        Suppress confirmation when removing a load balancer monitor.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('MonitorName')]
        [string[]]$Name = (Read-Host -Prompt 'Monitor name'),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Monitor')) {
                try {
                    $m = Get-NSLBMonitor -Session $Session -Name $item
                    $params = @{
                        type = $m.lbmonitor.type
                    }
                    $response = _InvokeNSRestApi -Session $Session -Method DELETE -Type lbmonitor -Resource $item -Arguments $params -Action delete
                    if ($response.errorcode -ne 0) { throw $response }
                } catch {
                    throw $_
                }
            }
        }
    }
}
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

#
#Doesn't work yet
#
function Enable-NSLBMonitor {
    <#
    .SYNOPSIS
        Enable load balancer monitoring object.

    .DESCRIPTION
        Enable load balancer monitoring object.

    .EXAMPLE
        Enable-NSLBMonitor -Name 'monitor01'

        Enable the monitor 'monitor01'.

    .EXAMPLE
        'monitor01', 'monitor02' | Enable-NSLBMonitor -Force
    
        Enable the monitors 'monitor01' and 'monitor02' without confimation.

    .EXAMPLE
        $monitor = Enable-NSLBMonitor -Name 'monitor01' -Force -PassThru

        Enable the monitor 'monitor01' without confirmation and return the resulting object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the monitor.

    .PARAMETER Force
        Suppress confirmation when enabling the monitor.

    .PARAMETER PassThru
        Return the load balancer monitor object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('MonitorName')]
        [string[]]$Name = (Read-Host -Prompt 'Monitor name'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable Monitor')) {
                try {
                    $m = Get-NSLBMonitor -Session $Session -Name $item

                    $params = @{
                        servicename = $m.servicename
                        servicegroupname = $m.servicegroupname
                        monitorname = $m.monitorname
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type lbmonitor -Payload $params -Action enable

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBMonitor -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
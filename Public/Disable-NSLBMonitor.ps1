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
function Disable-NSLBMonitor {
    <#
    .SYNOPSIS
        Disable load balancer monitoring object.

    .DESCRIPTION
        Disable load balancer monitoring object.

    .EXAMPLE
        Disable-NSLBMonitor -Name 'monitor01'

        Disable the monitor 'monitor01'.

    .EXAMPLE
        'monitor01', 'monitor02' | Disable-NSLBMonitor -Force
    
        Disable the monitors 'monitor01' and 'monitor02' without confimation.

    .EXAMPLE
        $monitor = Disable-NSLBMonitor -Name 'monitor01' -Force -PassThru

        Disable the monitor 'monitor01' without confimation and return the resulting object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer monitors to disable.

    .PARAMETER Force
        Suppress confirmation when disabling the monitor.

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
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Disable Monitor')) {
                try {
                    $m = Get-NSLBMonitor -Session $Session -Name $item

                    $params = @{
                        servicename = $m.servicename
                        servicegroupname = $m.servicegroupname
                        monitorname = $m.monitorname
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type lbmonitor -Payload $params -Action disable

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
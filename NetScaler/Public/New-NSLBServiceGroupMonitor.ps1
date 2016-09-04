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

function New-NSLBServiceGroupMonitor {
    <#
    .SYNOPSIS
        Adds a monitor to a service group.

    .DESCRIPTION
        Adds a monitor to a service group.

    .EXAMPLE
        New-NSLBServiceGroupMonitor -Name 'sg01' -MonitorName 'monitor01'

        Associates monitor 'monitor01' with service group 'sg01'

    .EXAMPLE
        $x = New-NSLBServiceGroupMonitor -Name 'sg01' -MonitorName 'monitor01' -MonitorState 'DISABLED' -PassThru

        Associates monitor 'monitor01' with service group 'sg01' initially in a DISABLED state and return the object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the service group to associated the server with.

    .PARAMETER MonitorName
        Name of the monitor to which to bind the service group.

    .PARAMETER Weight
        Weight to assign to the servers in the service group.
        Specifies the capacity of the servers relative to the other servers in the load balancing configuration.
        The higher the weight, the higher the percentage of requests sent to the service.

        Minimum value = 1
        Maximum value = 100

    .PARAMETER MonitorState
        Initial state of the monitor after binding.

    .PARAMETER Passthru
        Return the service group binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias('ServiceGroupName')]
        [string[]]$Name,

        [Parameter(Mandatory)]
        [string[]]$MonitorName,

        [ValidateRange(1, 100)]
        [int]$Weight = 1,

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$MonitorState = 'ENABLED',

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            foreach ($monitor in $MonitorName) {
                if ($PSCmdlet.ShouldProcess($item, "Add Service Group Monitor: $monitor")) {
                    try {
                        $params = @{
                            servicegroupname = $item
                            monitor_name = $monitor
                            weight = $Weight
                            monstate = $MonitorState
                        }
                        _InvokeNSRestApi -Session $Session -Method POST -Type servicegroup_lbmonitor_binding -Payload $params -Action add

                        if ($PSBoundParameters.ContainsKey('PassThru')) {
                            return Get-NSLBServiceGroupMonitorBinding -Session $session -Name $item
                        }
                    } catch {
                        throw $_
                    }
                }
            }
        }
    }
}


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

function Add-NSLBServiceMonitorBinding {
     <#
    .SYNOPSIS
        Adds a new service group monitor binding.

    .DESCRIPTION
        Adds a new service group monitor binding.

    .EXAMPLE
        Add-NSLBServiceMonitorBinding -ServiceName 'svc01' -MonitorName 'mon01'

        Bind the monitor 'mon01' to service 'svc01'.

    .EXAMPLE
        Add-NSLBServiceMonitorBinding -ServiceName 'svc01' -MonitorName 'mon01' -Force -PassThru

        Bind the monitor 'mon01' to service 'svc01', suppress the confirmation and return the result.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER ServiceName
        Name of the service to which to bind a policy or monitor.

    .PARAMETER MonitorName
        Name of the monitor to bind to the service.

    .PARAMETER Passive
        Indicates if load monitor is passive. A passive load monitor does not remove service from LB decision when threshold is breached.

    .PARAMETER Weight
        Weight to assign to the monitor-service binding. When a monitor is UP, the weight assigned to its binding with the service determines how much the monitor contributes toward keeping the health of the service above the value configured for the Monitor Threshold parameter.
        Minimum value = 1
        Maximum value = 100

    .PARAMETER Force
        Suppress confirmation when binding the certificate key to the virtual server.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$ServiceName,

        [parameter(Mandatory)]
        [string]$MonitorName,

        [ValidateRange(1,100)]
        [int]$Weight,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($ServiceName, 'Add Monitor Binding to Service')) {
            try {
                $params = @{
                    name = $ServiceName
                    monitor_name = $MonitorName
                }
                if ($PSBoundParameters.ContainsKey('Weight')) {
                    $params.Add('weight', $Weight)
                }

                _InvokeNSRestApi -Session $Session -Method PUT -Type service_lbmonitor_binding -Payload $params

                # if ($PSBoundParameters.ContainsKey('PassThru')) {
                #     return Get-NSLBServiceMonitorBinding -Session $Session -ServiceName $ServiceName
                # }
            } catch {
                throw $_
            }
        }
    }
}
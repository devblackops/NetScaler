<#
Copyright 2019 Olli Janatuinen

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
        Adds a new service monitor binding.

    .DESCRIPTION
        Adds a new service monitor binding.

    .EXAMPLE
        Add-NSLBServiceMonitorBinding -ServiceName 'sg01' -MonitorName 'mon01'

        Bind the monitor 'mon01' to service 'sg01'.

    .EXAMPLE
        Add-NSLBServiceMonitorBinding -ServiceName 'sg01' -MonitorName 'mon01' -Force -PassThru

        Bind the monitor 'mon01' to service 'sg01'', suppress the confirmation and return the result.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER ServiceName
        Name of the service to bind the monitor to.

    .PARAMETER MonitorName
        Name of the monitor to bind to the service.

    .PARAMETER Port
        Port number of the service. Each service must have a unique port number.

        Range: 1 - 65535

    .PARAMETER State
        Initial state of the service after binding.

        Default value: ENABLED
        Possible values: ENABLED, DISABLED

    .PARAMETER Weight
        Weight to assign to the servers in the service. Specifies the capacity of the servers relative to the other servers in the load balancing configuration. The higher the weight, the higher the percentage of requests sent to the service.

        Range: 1 - 100

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

        [ValidateSet('ENABLED','DISABLED')]
        [string]$State = 'ENABLED',

        [ValidateRange(1,100)]
        [int]$Weight,

        [ValidateRange(1,65535)]
        [int]$Port,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($ServiceName, 'Add Monitor Binding')) {
            try {
                $params = @{
                    name = $ServiceName
                    monitor_name = $MonitorName
                }
                if ($PSBoundParameters.ContainsKey('Weight')) {
                    $params.Add('weight', $Weight)
                }
                if ($PSBoundParameters.ContainsKey('Port')) {
                    $params.Add('port', $Port)
                }

                _InvokeNSRestApi -Session $Session -Method PUT -Type service_lbmonitor_binding -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServiceMonitorBinding -Session $Session -Name $ServiceName
                }
            } catch {
                throw $_
            }
        }
    }
}
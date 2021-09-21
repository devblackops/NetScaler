<#
Copyright 2016 Iain Brighton

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

function Remove-NSLBServiceGroupMonitorBinding {
    <#
    .SYNOPSIS
        Removes a monitor binding from a service group.

    .DESCRIPTION
        Removes a monitor binding from a service group.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the service group to unbind the monitor.

    .PARAMETER MonitorName
        The name of the monitor to unbind.

    .EXAMPLE
        Remove-NSLBServiceGroupMonitorBinding -Name 'sg01' -MonitorName 'mon01'

        Unbinds the monitor named 'mon01' from the service group 'sg01'.

    .PARAMETER Force
        Suppress confirmation when removing a responder action.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [alias('ServiceGroupName')]
        [string[]]$Name,

        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$MonitorName,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {

        $params =@{
            monitor_name = $MonitorName
        }
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Monitor Binding')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type servicegroup_lbmonitor_binding -Resource $item -Arguments $params -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}

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

function Get-NSLBServiceGroupMonitorBinding {
    <#
    .SYNOPSIS
        Gets the service group binding for a service group.

    .DESCRIPTION
        Gets the service group binding for a service group.

    .EXAMPLE
        Get-NSLBServiceGroupMonitorBinding -Name $sg

        Gets the service group bindings for the 'sg' service group.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the service group to get the service group member binding for.

    .PARAMETER MonitorName
        Filters the returned monitors to only include the name specified
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [parameter()]
        [string]$MonitorName
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            # Contruct a filter hash if we specified any filters
            $Filters = @{}
            if ($PSBoundParameters.ContainsKey('MonitorName')) {
                $Filters['monitor_name'] = $MonitorName
            }
            _InvokeNSRestApiGet -Session $Session -Type servicegroup_lbmonitor_binding -Name $Name -Filters $Filters
        }
        catch {
            throw $_
        }
    }
}

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

function Get-NSLBServiceMonitorBinding {
    <#
    .SYNOPSIS
        Gets the monitor binding for a service.

    .DESCRIPTION
        Gets the monitor binding for a service.

    .EXAMPLE
        Get-NSLBServiceMonitorBinding -ServiceName $svc

        Gets the monitor bindings for the 'svc' service.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER ServiceName
        The name or names of the monitor to get the service binding for.

    .PARAMETER MonitorName
        Filters the returned monitors to only include the name specified
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$ServiceName,

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
            _InvokeNSRestApiGet -Session $Session -Type service_lbmonitor_binding -Name $ServiceName -Filters $Filters
        }
        catch {
            throw $_
        }
    }
}

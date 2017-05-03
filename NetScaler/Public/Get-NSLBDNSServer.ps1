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

function Get-NSLBDNSServer {
    <#
    .SYNOPSIS
        Gets the specified load balancer virtual server object.

    .DESCRIPTION
        Gets the specified load balancer virtual server object.

    .EXAMPLE
        Get-NSLBVirtualServer

        Get all load balancer virtual server objects.

    .EXAMPLE
        Get-NSLBVirtualServer -Name 'vserver01'
    
        Get the load balancer virtual server named 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual server to get.

    .PARAMETER Port
        Filter load balancer virtual servers by port.

    .PARAMETER ServiceType
        Filter load balancer virtual servers by service type.

    .PARAMETER LBMethod
        Filter load balancer virtual servers by load balancing method.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter(Position=0)]
        [string]$filter

    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        # Contruct a filter hash if we specified any filters
        $filters = @{}
        if ($PSBoundParameters.ContainsKey('ip')) {
            $filters.'ip' = $Name
        }
        if ($PSBoundParameters.ContainsKey('Port')) {
            $filters.'port' = $Port
        }
        if ($PSBoundParameters.ContainsKey('ServiceType')) {
            $filters.'servicetype' = $ServiceType
        }
        if ($PSBoundParameters.ContainsKey('LBMethod')) {
            $filters.'lbmethod' = $LBMethod
        }

        # If we specified any filters, filter based on them
        # Otherwise, get everything
        if ($filters.count -gt 0) {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type lbvserver -Action Get -Filters $filters
        } else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type lbvserver -Action Get
        }
        if ($response.errorcode -ne 0) { throw $response }
        if ($response.psobject.properties | where name -eq lbvserver) {
            return $response.lbvserver
        }
    }
}
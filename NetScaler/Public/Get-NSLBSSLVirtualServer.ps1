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

function Get-NSLBSSLVirtualServer {
    <#
    .SYNOPSIS
        Gets the specified load balancer SSL virtual server object.

    .DESCRIPTION
        Gets the specified load balancer SSL virtual server object.

    .EXAMPLE
        Get-NSLBSSLVirtualServer

        Get all load balancer SSL virtual server objects.

    .EXAMPLE
        Get-NSLBSSLVirtualServer -Name 'vserver01'

        Get the load balancer SSL virtual server named 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer SSL virtual server to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter(Position=0)]
        [string]$Name
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        # Contruct a filter hash if we specified any filters
        $filters = @{}
        if ($PSBoundParameters.ContainsKey('Name')) {
            $filters.'vservername' = $Name
        }

        # If we specified any filters, filter based on them
        # Otherwise, get everything
        if ($filters.count -gt 0) {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type sslvserver -Action Get -Filters $filters
        } else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type sslvserver -Action Get
        }
        if ($response.errorcode -ne 0) { throw $response }
        if ($response.psobject.properties | Where-Object {$_.name -eq 'sslvserver'}) {
            return $response.sslvserver
        }
    }
}
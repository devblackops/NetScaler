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

function Get-NSLBVirtualServerBinding {
    <#
    .SYNOPSIS
        Gets the specified load balancer virtual server binding object.

    .DESCRIPTION
        Gets the specified load balancer virtual server binding object.

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
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type lbvserver_servicegroup_binding -Resource $item
                if ($response.errorcode -ne 0) { throw $response }
                if ($response.PSobject.Properties.name -contains 'lbvserver_servicegroup_binding') {
                    $response.lbvserver_servicegroup_binding
                }                
            }    
        } else {
            $vServers = Get-NSLBVirtualServer -Session $Session -Verbose:$false
            foreach ($item in $vServers) {
                $bindings = _InvokeNSRestApi -Session $Session -Method Get -Type lbvserver_servicegroup_binding -Resource $item.name
                if ($bindings.errorcode -ne 0) { throw $bindings }
                if ($bindings.PSobject.Properties.name -contains 'lbvserver_servicegroup_binding') {
                    $bindings.lbvserver_servicegroup_binding
                }
            }
        }
    }
}
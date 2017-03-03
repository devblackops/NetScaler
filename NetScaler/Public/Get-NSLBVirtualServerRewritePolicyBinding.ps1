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

function Get-NSLBVirtualServerRewritePolicyBinding {
    <#
    .SYNOPSIS
        Gets the rewrite policy binding objects for the specified load balancer 
        virtual server.

    .DESCRIPTION
        Gets the rewrite policy binding objects for the specified load balancer 
        virtual server.

    .EXAMPLE
        Get-NSLBVirtualServerRewritePolicyBinding

        Get all load balancer virtual server rewrite policy bindings.

    .EXAMPLE
        Get-NSLBVirtualServerRewritePolicyBinding -Name 'vserver01'

        Get the rewrite policy bindings for the load balancer virtual server named 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual server to get policy bindings for.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $result = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type lbvserver_rewritepolicy_binding -Resource $item
                if ($response.errorcode -ne 0) { throw $response }

                foreach ($entry in $response) {
                    if ($entry.PSobject.Properties.name -contains 'lbvserver_rewritepolicy_binding') {
                        $result += $entry.lbvserver_rewritepolicy_binding
                    }
                }
            }
        } else {
            $vServers = Get-NSLBVirtualServer -Session $Session -Verbose:$false
            foreach ($item in $vServers) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type lbvserver_rewritepolicy_binding -Resource $item.name
                if ($response.errorcode -ne 0) { throw $bindings }
                if ($response.PSobject.Properties.name -contains 'lbvserver_rewritepolicy_binding') {
                    $result += $response.lbvserver_rewritepolicy_binding
                }
            }
        }
        return $result
    }
}
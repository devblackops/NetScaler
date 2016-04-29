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

function Get-NSLBServer {
    <#
    .SYNOPSIS
        Gets the specified load balancer server object.

    .DESCRIPTION
        Gets the specified load balancer server object.

    .EXAMPLE
        Get-NSLBServer

        Get all load balancer server objects.

    .EXAMPLE
        Get-NSLBServer -Name 'server01'
    
        Get the load balancer server named 'server01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer servers to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type server -Resource $item -Action Get 
                if ($response.errorcode -ne 0) { throw $response }
                if ($Response.psobject.properties.name -contains 'server') {
                    $response.server
                }
            }
        } else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type server -Action Get
            if ($response.errorcode -ne 0) { throw $response }
            if ($Response.psobject.properties.name -contains 'server') {
                $response.server
            }
        }
    }
}
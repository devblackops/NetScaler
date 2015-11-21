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

function Get-NSLBServiceGroup {
    <#
    .SYNOPSIS
        Gets the specified load balancer service group object.

    .DESCRIPTION
        Gets the specified load balancer service group object.

    .EXAMPLE
        Get-NSLBServiceGroup

        Get all load balancer service group objects.

    .EXAMPLE
        Get-NSLBServiceGroup -Name 'sg01'
    
        Get the load balancer service group named 'sg01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer service group to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $serviceGroups = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $serviceGroups = _InvokeNSRestApi -Session $Session -Method Get -Type servicegroup -Action Get -Resource $item
                return $serviceGroups.servicegroup
            }
        } else {
            $serviceGroups = _InvokeNSRestApi -Session $Session -Method Get -Type servicegroup -Action Get
            return $serviceGroups.servicegroup
        }
    }
}
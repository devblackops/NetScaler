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

function Get-NSLBStat {
    <#
    .SYNOPSIS
        Gets the specified load balancer stat object.

    .DESCRIPTION
        Gets the specified load balancer stat object.

    .EXAMPLE
        Get-NSLBStat

        Get all load balancer stat objects.

    .EXAMPLE
        Get-NSLBStat -Name 'stat01'
    
        Get the load balancer stat named 'stat01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer stat to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $stats = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $stats = _InvokeNSRestApi -Session $Session -Method Get -Type servicegroup -Stat -Resource $item
                return $stats.servicegroup
            }
        } else {
            $stats = _InvokeNSRestApi -Session $Session -Method Get -Type servicegroup -Stat
            return $stats.servicegroup
        }
    }
}
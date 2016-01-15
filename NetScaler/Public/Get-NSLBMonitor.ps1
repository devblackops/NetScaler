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

function Get-NSLBMonitor {
    <#
    .SYNOPSIS
        Gets the specified load balancer monitoring object.

    .DESCRIPTION
        Gets the specified load balancer monitoring object.

    .EXAMPLE
        Get-NSLBMonitor

        Get all load balancer monitor objects.

    .EXAMPLE
        Get-NSLBMonitor -Name 'monitor01'
    
        Get the load balancer monitor named 'monitor01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer monitors to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $monitors = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $monitors = _InvokeNSRestApi -Session $Session -Method Get -Type lbmonitor -Action Get -Resource $item
                return $monitors.lbmonitor
            }
        } else {
            $monitors = _InvokeNSRestApi -Session $Session -Method Get -Type lbmonitor -Action Get
            return $monitors.lbmonitor
        }
    }
}
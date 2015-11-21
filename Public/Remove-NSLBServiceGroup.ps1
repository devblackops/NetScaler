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

function Remove-NSLBServiceGroup {
    <#
    .SYNOPSIS
        Removes a load balancer service group.

    .DESCRIPTION
        Removes a load balancer service group.

    .EXAMPLE
        Remove-NSLBServiceGroup -Name 'sg01'

        Removes the load balancer service group named 'sg01'.

    .EXAMPLE
        'sg01', 'sg02' | Remove-NSLBServiceGroup
    
        Removes the load balancer service groups named 'sg01' and 'sg02'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer service group to get.

    .PARAMETER Force
        Suppress confirmation when removing a load balancer service group.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [Alias('servicegroupname')]
        [string[]]$Name = (Read-Host -Prompt 'LB service group name'),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Service Group')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type servicegroup -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
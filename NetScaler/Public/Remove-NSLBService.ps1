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

function Remove-NSLBService {
    <#
    .SYNOPSIS
        Removes the specified load balancer service object.

    .DESCRIPTION
        Removes the specified load balancer service object.

    .EXAMPLE
        Remove-NSLBService -Name 'service01'
    
        Removes the load balancer service named 'service01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer service to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @(),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
        $service = @()
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Service')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type service -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
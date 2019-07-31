<#
Copyright 2019 Olli Janatuinen

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
        Removes a load balancer service.

    .DESCRIPTION
        Removes a load balancer service.

    .EXAMPLE
        Remove-NSLBService -Name 'sg01'

        Removes the load balancer service named 'sg01'.

    .EXAMPLE
        'sg01', 'sg02' | Remove-NSLBService
    
        Removes the load balancer services named 'sg01' and 'sg02'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer service to get.

    .PARAMETER Force
        Suppress confirmation when removing a load balancer service.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [Alias('servicename')]
        [string[]]$Name = (Read-Host -Prompt 'LB service name'),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
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
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

function Get-NSLBService {
    <#
    .SYNOPSIS
        Gets the specified load balancer service object.

    .DESCRIPTION
        Gets the specified load balancer service object.

    .EXAMPLE
        Get-NSLBService

        Get all load balancer service objects.

    .EXAMPLE
        Get-NSLBService -Name 'sg01'
    
        Get the load balancer service named 'sg01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer service to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $services = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $services = _InvokeNSRestApi -Session $Session -Method Get -Type service -Action Get -Resource $item
                if ($Services.psobject.properties.name -contains 'service') {
                    return $services.service
                }
            }
        } else {
            $services = _InvokeNSRestApi -Session $Session -Method Get -Type service -Action Get
            if ($Services.psobject.properties.name -contains 'service') {
                return $services.service
            }
        }
    }
}
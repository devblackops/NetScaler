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

function Get-NSFeature {
    <#
    .SYNOPSIS
        Gets the feature status for the NetScaler appliance.

    .DESCRIPTION
        Gets the feature status for the NetScaler appliance.

    .EXAMPLE
        Get-NSFeature

        Get status for all the NetScaler features.

    .EXAMPLE
        Get-NSFeature -Name 'sslvpn'
    
        Get the status of NetScaler feature 'sslvpn'.

    .EXAMPLE
        'sslvpn', 'lb' | Get-NSFeature
    
        Get the status of NetScaler feature 'sslvpn' and 'lb'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of NetScaler features to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $features = @()
    }

    process {
        if ($Name.Count -gt 0) {
            $all = _InvokeNSRestApi -Session $Session -Method Get -Type nsfeature -Action Get
            foreach ($item in $Name) {
                $features += $all.nsfeature.$item
            }
            return $features
        } else {
            $features = _InvokeNSRestApi -Session $Session -Method Get -Type nsfeature -Action Get
            return $features.nsfeature
        }
    }
}
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

function Get-NSMode {
    <#
    .SYNOPSIS
        Gets the mode status for the NetScaler appliance.

    .DESCRIPTION
        Gets the mode status for the NetScaler appliance.

    .EXAMPLE
        Get-NSMode

        Get status for all the NetScaler modes.

    .EXAMPLE
        Get-NSMode -Name 'l3'
    
        Get the status of NetScaler mode 'l3'.

    .EXAMPLE
        'l3', 'fr' | Get-NSMode
    
        Get the status of NetScaler feature 'l3' and 'fr'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of NetScaler modes to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        $modes = @()
    }

    process {
        if ($Name.Count -gt 0) {
            $all = _InvokeNSRestApi -Session $Session -Method Get -Type nsmode -Action Get
            foreach ($item in $Name) {
                $modes += $all.nsmode.$item
            }
            return $modes
        } else {
            $modes = _InvokeNSRestApi -Session $Session -Method Get -Type nsmode -Action Get
            return $modes.nsmode
        }
    }
}
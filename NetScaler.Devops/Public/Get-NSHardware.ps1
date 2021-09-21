<#
Copyright 2017 Dominique Broeglin

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

function Get-NSHardware {
    <#
    .SYNOPSIS
        Gets the hardware information for the NetScaler appliance.

    .DESCRIPTION
        Gets the hardware information for the NetScaler appliance.

    .EXAMPLE
        Get-NSHardware

        Get the NetScaler hardware information.

    .EXAMPLE
        Get-NSHardware | Select-Object -ExpandProperty host

        Get the NetScaler host ID (used for licenses). For some reason the 'hostid' property contains 
        another, numeric, value. 

    .PARAMETER Session
        The NetScaler session object.

    #>
    [cmdletbinding()]
    param(
        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        _InvokeNSRestApiGet -Session $Session -Type nshardware
    }
}

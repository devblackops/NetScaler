<#
Copyright 2016 Dominique Broeglin

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

function Clear-NSAAASession {
    <#
    .SYNOPSIS
        Clear NetScaler AAA sessions.

    .DESCRIPTION
        Clear NetScaler AAA sessions.

    .EXAMPLE
        Clear-NSAAASessions

        Clears all AAA sessions.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Force
        Suppress confirmation when clearing the sessions.

    .Notes
        Nitro implementation status: partial    
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $Script:Session,
        
        [switch]$Force        
    )

    begin {
        _AssertSessionActive
    }
    process {
        $ip = $($Session.EndPoint)
        if ($Force -or $PSCmdlet.ShouldProcess($ip, "Clear AAA sessions")) {
            _InvokeNSRestApi -Session $Session -Method POST -Type aaasession -Action kill -Payload @{ "all" = $True }
        }
    }
}
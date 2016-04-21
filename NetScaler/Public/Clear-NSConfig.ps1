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

function Clear-NSConfig {
    <#
    .SYNOPSIS
        Clear NetScaler configuration.

    .DESCRIPTION
        Clear NetScaler configuration and reset it to factory defaults.

    .EXAMPLE
        Clear-NSConfig

    .EXAMPLE
        Clear-NSConfig -Level Full

        Fully clears the netscaler configuration.
        
    .PARAMETER Level
        Parameters that defines how much of the configuration is cleared.
        See http://support.citrix.com/article/CTX112695 for more details.

        Default value: Basic
        Possible values: Basic, Extended, Full
        
    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Force
        Suppress confirmation when clearing the configuration.

    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $Script:Session,
        
        [ValidateSet('Basic', 'Extended', 'Full')]
        [string]$Level = 'Basic',
        
        [switch]$Force        
    )

    begin {
        _AssertSessionActive
    }

    process {
        $ip = $($Session.EndPoint)
        if ($Force -or $PSCmdlet.ShouldProcess($ip, "Clear configuration ($Level level)")) {
            _InvokeNSRestApi -Session $Session -Method POST -Type nsconfig -Action clear -Payload @{ "level" = $Level }
        }
    }
}
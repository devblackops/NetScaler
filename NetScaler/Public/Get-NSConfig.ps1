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

function Get-NSConfig {
    <#
    .SYNOPSIS
        Gets the specified Netscaler configuration.

    .DESCRIPTION
        Gets the specified Netscaler configuration. The returned configuration is an
        array of strings. Each string represents a configuration line. Comments, empty 
        lines and the " Done" line are prunned.

    .EXAMPLE
        Get-NSConfig

        Get the running configuration.

    .EXAMPLE
        Get-NSConfig -State saved
    
        Get the saved configuration

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER State
        The state of the configuration that should be returned. Defaults to 'running'.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [ValidateSet('running', 'saved')]
        [string]$State = 'running'
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($State -eq 'running') {
            $Config = (_InvokeNSRestApi -Session $Session -Method Get -Type nsrunningconfig -Action GetAll).nsrunningconfig.response
        } else {
            $Config = (_InvokeNSRestApi -Session $Session -Method Get -Type nssavedconfig -Action GetAll).nssavedconfig.textblob            
        }
        $Config -Split '\n' | Where-Object { $_ -and !($_ -match "^( Done| *#)") }
    }
}
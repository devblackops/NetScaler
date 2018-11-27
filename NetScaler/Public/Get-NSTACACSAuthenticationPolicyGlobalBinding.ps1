<#
Copyright 2018 Iain Brighton

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

function Get-NSTACACSAuthenticationPolicyGlobalBinding {
     <#
    .SYNOPSIS
        Gets the specified global TACACS+ authentication policy binding(s).

    .DESCRIPTION
        Gets the specified global TACACS+ authentication policy binding(s).

    .EXAMPLE
        Get-NSTACACSAuthenticationPolicyGlobalBinding 

        Gets all global TACACS+ authentication policy bindings.

    .EXAMPLE
        Get-NSTACACSAuthenticationPolicyGlobalBinding -Nane 'CISCO01'

        Gets the global TACACS+ authentication policy binding named 'CISCO01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the global TACACS+ authentication policy binding(s) to return.

    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position = 0)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        _InvokeNSRestApiGet -Session $Session -Type systemglobal_authenticationtacacspolicy_binding -Filters @{ policyname = $Name }
    }
}

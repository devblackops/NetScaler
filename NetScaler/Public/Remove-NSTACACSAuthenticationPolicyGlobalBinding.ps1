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

function Remove-NSTACACSAuthenticationPolicyGlobalBinding {
    <#
    .SYNOPSIS
        Removes a global TACACS+ authentication policy binding.

    .DESCRIPTION
        Removes a global TACACS+ authentication policy binding.

    .EXAMPLE
        Remove-NSTACACSAuthenticationPolicyGlobalBinding -Name 'policy_tacacs_cisco01'

        Unbinds the global TACACS+ authentication policy 'policy_tacacs_cisco01' from the system.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the TACACS+ authentication policy to unbind.
    
    .PARAMETER Force
        Suppress confirmation when removing object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        $Session = $Script:Session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete global TACACS+ Authentication Policy binding')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type systemglobal_authenticationtacacspolicy_binding -Arguments @{ policyname = $item }
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

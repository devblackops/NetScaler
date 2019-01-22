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

function Remove-NSAuthenticationPolicyGlobalBinding {
    <#
    .SYNOPSIS
        Removes a global authentication policy binding.

    .DESCRIPTION
        Removes a global authentication policy binding.

    .EXAMPLE
        Remove-NSAuthenticationPolicyGlobalBinding -Name 'policy_tacacs_cisco01' -Type TACACS

        Unbinds the global TACACS+ authentication policy 'policy_tacacs_cisco01' from the system.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER LDAPAuthenticationPolicyName
        Name of the global LDAP authentication policy binding to unbind.

    .PARAMETER RADIUSAuthenticationPolicyName
        Name of the global RADIUS authentication policy binding to unbind.

    .PARAMETER TACACSAuthenticationPolicyName
        Name of the global TACACS+ authentication policy binding to unbind.
    
    .PARAMETER Force
        Suppress confirmation when removing object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', DefaultParameterSetName = 'ldapauthenticationpolicy')]
    param(
        $Session = $Script:Session,

        [parameter(Mandatory = $true, ParameterSetName='ldapauthenticationpolicy')]
        [string[]] $LDAPAuthenticationPolicyName = @(),
        
        [parameter(Mandatory = $true, ParameterSetName='radiusauthenticationpolicy')]
        [string[]] $RADIUSAuthenticationPolicyName = @(),

        [parameter(Mandatory = $true, ParameterSetName='tacacsauthenticationpolicy')]
        [string[]] $TACACSAuthenticationPolicyName = @(),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ldapauthenticationpolicy' {
                $bindingType = 'systemglobal_authenticationldappolicy_binding'
                $policyName = $LDAPAuthenticationPolicyName
            }
            'radiusauthenticationpolicy' {
                $bindingType = 'systemglobal_authenticationradiuspolicy_binding'
                $policyName = $RADIUSAuthenticationPolicyName
            }
            'tacacsauthenticationpolicy' {
                $bindingType = 'systemglobal_authenticationtacacspolicy_binding'
                $policyName = $TACACSAuthenticationPolicyName
            }
        }

        foreach ($item in $policyName) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete global Authentication policy binding')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type $bindingType -Arguments @{ policyname = $item }
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

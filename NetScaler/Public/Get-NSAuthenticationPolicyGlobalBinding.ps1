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

function Get-NSAuthenticationPolicyGlobalBinding {
     <#
    .SYNOPSIS
        Gets the specified global authentication policy binding(s).

    .DESCRIPTION
        Gets the specified global authentication policy binding(s).

    .EXAMPLE
        Get-NSAuthenticationPolicyGlobalBinding -LDAPAuthenticationPolicyName *

        Gets all global LDAP authentication policy bindings.
    
    .EXAMPLE
        Get-NSAuthenticationPolicyGlobalBinding -TACACSAuthenticationPolicyName 'CISCO01'

        Gets the global TACACS+ authentication policy binding named 'CISCO01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER LDAPAuthenticationPolicyName
        Name of the global LDAP authentication policy binding to retrieve.

    .PARAMETER RADIUSAuthenticationPolicyName
        Name of the global RADIUS authentication policy binding to retrieve.

    .PARAMETER TACACSAuthenticationPolicyName
        Name of the global TACACS+ authentication policy binding to retrieve.
    #>
    [cmdletbinding(DefaultParameterSetName = 'ldapauthenticationpolicy')]
    param(
        $Session = $Script:Session,

        [parameter(ParameterSetName='ldapauthenticationpolicy')]
        [string[]] $LDAPAuthenticationPolicyName,
        
        [parameter(Mandatory, ParameterSetName='radiusauthenticationpolicy')]
        [string[]] $RADIUSAuthenticationPolicyName,

        [parameter(Mandatory, ParameterSetName='tacacsauthenticationpolicy')]
        [string[]] $TACACSAuthenticationPolicyName
    )

    begin {
        _AssertSessionActive
    }

    process {
        $policyName = @()
        switch ($PSCmdlet.ParameterSetName) {
            'ldapauthenticationpolicy' {
                $bindingType = 'systemglobal_authenticationldappolicy_binding'
                if ($LDAPAuthenticationPolicyName -ne '*') { $policyName = $LDAPAuthenticationPolicyName }
            }
            'radiusauthenticationpolicy' {
                $bindingType = 'systemglobal_authenticationradiuspolicy_binding'
                if ($RADIUSAuthenticationPolicyName -ne '*') { $policyName = $RADIUSAuthenticationPolicyName }
            }
            'tacacsauthenticationpolicy' {
                $bindingType = 'systemglobal_authenticationtacacspolicy_binding'
                if ($TACACSAuthenticationPolicyName -ne '*') { $policyName = $TACACSAuthenticationPolicyName }
            }
        }
        _InvokeNSRestApiGet -Session $Session -Type $bindingType -Filters @{ policyname = $policyName }
    }
}

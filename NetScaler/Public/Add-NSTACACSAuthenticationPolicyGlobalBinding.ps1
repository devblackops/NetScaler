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

function Add-NSTACACSAuthenticationPolicyGlobalBinding {
     <#
    .SYNOPSIS
        Adds a new global system TACACS+ authentication policy binding.

    .DESCRIPTION
        Adds a new global system TACACS+ authentication policy binding.

    .EXAMPLE
        Add-NSTACACSAuthenticationPolicyGlobalBinding -Name 'policy_tacacs_cisco01' -Priority 100

        Bind the TACACS+ authentication policy named 'policy_tacacs_cisco01' globally with a priority of '100'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the TACACS+ authentication policy to bind globally.

    .PARAMETER Priority
        The priority of the authentication policy binding.

    .PARAMETER Type
        The type of global binding to create.

        Default value: SYSTEM_GLOBAL
        Possible values = SYSTEM_GLOBAL, VPN_GLOBAL, RNAT_GLOBAL

    .PARAMETER Passthru
        Return the binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $Script:Session,

        [parameter(Mandatory, Position=0)]
        [string]$Name,

        [parameter()]
        [int]$Priority,

        [parameter()]
        [ValidateSet('SYSTEM_GLOBAL', 'VPN_GLOBAL', 'RNAT_GLOBAL')]
        [string]$Type = 'SYSTEM_GLOBAL',

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Add TACACS+ Authentication Policy Global Binding')) {
            try {
                $params = @{
                    policyname = $Name
                    priority = $Priority
                    globalbindtype = $Type
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type systemglobal_authenticationtacacspolicy_binding -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSTACACSAuthenticationPolicyGlobalBinding -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}
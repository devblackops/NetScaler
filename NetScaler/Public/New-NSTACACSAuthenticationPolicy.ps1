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

function New-NSTACACSAuthenticationPolicy {
    <#
    .SYNOPSIS
        Creates a new TACACS+ authentication policy object.

    .DESCRIPTION
        Creates a new TACACS+ authentication policy object.

    .EXAMPLE
        New-NSTACACSAuthenticationPolicy -Name 'policy_tacacs_cisco01' -Rule 'ns_true' -Action 'CISCO01'

        Creates a new TACACS+ authentication policy named 'policy_tacacs_cisco01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the TACACS+ authentication policy object to create.

    .PARAMETER Rule
        Name of the NetScaler named rule, or a default syntax expression, that the policy uses to determine whether to attempt to authenticate the user with the LDAP server..

    .PARAMETER Action
        Name of the TACACS+ action (server) to perform if the policy matches.

    .PARAMETER Passthru
        Return the TACACS+ authentication policy object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $Script:Session,

        [parameter(Mandatory, Position=0)]
        [string]$Name,

        [parameter(Mandatory)]
        [string]$Rule,

        [parameter(Mandatory)]
        [string]$Action,

        [switch] $PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Add TACACS+ Authentication Policy')) {
            try {
                $params = @{
                    name = $Name
                    rule = $Rule
                }
                if ($PSBoundParameters.ContainsKey('Action')) {
                    $params.Add('reqaction', $Action)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type authenticationtacacspolicy -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSTACACSAuthenticationPolicy -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

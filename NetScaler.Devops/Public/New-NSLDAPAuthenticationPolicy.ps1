<#
Copyright 2016 Iain Brighton

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

function New-NSLDAPAuthenticationPolicy {
    <#
    .SYNOPSIS
        Creates a new LDAP authentication policy object.

    .DESCRIPTION
        Creates a new LDAP authentication policy object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the LDAP authentication policy object to create.

    .PARAMETER Rule
        Name of the NetScaler named rule, or a default syntax expression, that the policy uses to determine whether to attempt to authenticate the user with the LDAP server..

    .PARAMETER Action
        Name of the LDAP action (server) to perform if the policy matches.

    .PARAMETER Passthru
        Return the LDAP authentication policy object.

    .EXAMPLE
        New-NSLDAPAuthenticationPolicy -Name 'policy_ldap_dc1' -Rule 'ns_true' -Action 'ldap_dc1'

        Creates a new LDAP authentication policy named 'policy_ldap_dc1'.
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
        if ($PSCmdlet.ShouldProcess($Name, 'Add LDAP Authentication Policy')) {
            try {
                $params = @{
                    name = $Name
                    rule = $Rule
                }
                if ($PSBoundParameters.ContainsKey('Action')) {
                    $params.Add('reqaction', $Action)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type authenticationldappolicy -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLDAPAuthenticationPolicy -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

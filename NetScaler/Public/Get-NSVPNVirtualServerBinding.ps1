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

function Get-NSVPNVirtualServerBinding {
    <#
    .SYNOPSIS
        Gets the specified NetScaler Gateway virtual server binding object.

    .DESCRIPTION
        Gets the specified NetScaler Gateway virtual server binding object.

    .EXAMPLE
        Get-NSVPNVirtualServerBinding -Name 'ag01' -Binding SessionPolicy

        Get all bound session policies from the 'ag01' NetScaler Gateway virtual server object.

    .EXAMPLE
        Get-NSVPNVirtualServerBinding -Name 'ag01' -Binding LDAPAuthenticationPolicy -PolicyName 'policy_ldap1'

        Get LDAP authentication policy named 'policy_ldap1' bound to the 'ag01' NetScaler Gateway virtual server object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the NetScaler Gateway virtual server to retrieve the bindings.

    .PARAMETER Binding
        Type of policy binding to query.

        Possible values: SessionPolicy, LDAPAuthenticationPolicy, STAServer, RADIUSAuthenticationPolicy, VPNUrl

    .PARAMETER PolicyName
        Name of the bound policy (or STA server/URL) to retrieve from the NetScaler Gateway virtual server.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [ValidateSet('SessionPolicy','LDAPAuthenticationPolicy','STAServer','RADIUSAuthenticationPolicy','SAMLAuthenticationPolicy','VPNUrl')]
        [string]$Binding,

        [parameter(Mandatory)]
        [string[]]$Name,

        [string]$PolicyName
    )

    process {
        try {
            switch ($Binding) {
                'SessionPolicy' { $policyType = 'vpnvserver_vpnsessionpolicy_binding' }
                'LDAPAuthenticationPolicy' { $policyType = 'vpnvserver_authenticationldappolicy_binding' }
                'STAServer' { $policyType = 'vpnvserver_staserver_binding' }
                'RADIUSAuthenticationPolicy' { $policyType = 'vpnvserver_authenticationradiuspolicy_binding' }
                'SAMLAuthenticationPolicy' { $policyType = 'vpnvserver_authenticationsamlpolicy_binding' }
                'VPNUrl' { $policyType = 'vpnvserver_vpnurl_binding' }
            }

            $filters = @{}

            if ($PSBoundParameters.ContainsKey('PolicyName')) {
                if ($Binding -eq 'STAServer') {
                    ## STA servers are not policies and are filtered based upon name
                    $filters.Add('staserver', $PolicyName)
                }
                elseif ($Binding -eq 'VPNUrl') {
                    ## URLs are not policies and are filtered based upon name
                    $filters.Add('urlname', $PolicyName)
                }
                else {
                    $filters.Add('policy', $PolicyName)
                }
            }

            _InvokeNSRestApiGet -Session $Session -Type $policyType -Name $Name -Filters $filters
        }
        catch {
            throw $_
        }
    }
}

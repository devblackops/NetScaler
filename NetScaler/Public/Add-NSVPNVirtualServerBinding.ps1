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

function Add-NSVPNVirtualServerBinding {
     <#
    .SYNOPSIS
        Adds a NetScaler Gateway virtual server binding.

    .DESCRIPTION
        Adds a NetScaler Gateway virtual server binding.

    .EXAMPLE
        Add-NSVPNVirtualServerBinding -Name 'ag01' -LDAPAuthenticationPolicyName 'policy_ldap01'

        Bind the LDAP authentication policy named 'policy_ldap01' to the NetScaler Gateway virtual server 'ag01'.

    .EXAMPLE
        Add-NSVPNVirtualServerBinding -Name 'ag01' -RADIUSAuthenticationPolicyName 'policy_radius_nps01' -Secondary

        Bind the secondaty RADIUS authentication policy named 'policy_radius_nps01' to the NetScaler Gateway virtual server 'ag01'.

    .EXAMPLE
        Add-NSVPNVirtualServerBinding -Name 'ag01' -SessionPolicyName 'policy_receiver'

        Bind the session named 'policy_receiver' to the NetScaler Gateway virtual server 'ag01'.

    .EXAMPLE
        Add-NSVPNVirtualServerBinding -Name 'ag01' -STAServer 'https://xddc1.lab.local'

        Bind the STA server 'https://xddc1.lab.local' to the NetScaler Gateway virtual server 'ag01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the virtual server. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain
        only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@), equal sign (=),
        and hyphen (-) characters. Can be changed after the virtual server is created.

        Minimum length = 1

    .PARAMETER LDAPAuthenticationPolicyName
        The LDAP authentication policy name to bind to the NetScaler Gateway virtual server.

    .PARAMETER RADIUSAuthenticationPolicyName
        The RADIUS authentication policy name to bind to the NetScaler Gateway virtual server.

    .PARAMETER SAMLAuthenticationPolicyName
        The SAML authentication policy name to bind to the NetScaler Gateway virtual server.

    .PARAMETER VPNUrlName
        The VPN Url/Bookmark name to bind to the NetScaler Gateway virtual server.

    .PARAMETER SessionPolicyName
        The LDAP authentication policy name to bind to the NetScaler Gateway virtual server.

    .PARAMETER STAServer
        The Secure Ticketing Authority URL to bind to the NetScaler Gateway virtual server.

    .PARAMETER Priority
        The priority, if any, of the VPN virtual server policy.

    .PARAMETER Secondary
        Bind the authentication policy as the secondary policy to use in a two-factor configuration. A user must then
        authenticate not only to a primary authentication server but also to a secondary authentication server. User
        groups are aggregated across both authentication servers. The user name must be exactly the same on
        both authentication servers, but the authentication servers can require different passwords.

    .PARAMETER Force
        Suppress confirmation when binding the service group to the virtual server.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium', DefaultParameterSetName = 'sessionpolicy')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [alias('VirtualServerName')]
        [string]$Name,

        [parameter(Mandatory, ParameterSetName='ldapauthenticationpolicy')]
        [string]$LDAPAuthenticationPolicyName,

        [parameter(Mandatory, ParameterSetName='radiusauthenticationpolicy')]
        [string]$RADIUSAuthenticationPolicyName,
        
        [parameter(Mandatory, ParameterSetName='samlauthenticationpolicy')]
        [string]$SAMLAuthenticationPolicyName,

        [parameter(Mandatory, ParameterSetName='sessionpolicy')]
        [string]$SessionPolicyName,

        [parameter(Mandatory, ParameterSetName='vpnurl')]
        [string]$VPNUrlName,

        [parameter(Mandatory, ParameterSetName='staserver')]
        [string]$STAServer,

        [parameter(ParameterSetName='ldapauthenticationpolicy')]
        [parameter(ParameterSetName='radiusauthenticationpolicy')]
        [parameter(ParameterSetName='samlauthenticationpolicy')]
        [parameter(ParameterSetName='sessionpolicy')]
        [ValidateRange(1, 1000)]
        [int]$Priority,

        [parameter(ParameterSetName='ldapauthenticationpolicy')]
        [parameter(ParameterSetName='radiusauthenticationpolicy')]
        [parameter(ParameterSetName='samlauthenticationpolicy')]
        [parameter(ParameterSetName='sessionpolicy')]
        [Switch]$Secondary,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($Name, 'Add NetScaler Gateway Virtual Server Binding')) {
            try {
                $params = @{
                    name = $Name
                }
                if ($PSBoundParameters.ContainsKey('Secondary')) {
                    $params.Add('secondary', $Secondary.ToBool())
                }
                if ($PSBoundParameters.ContainsKey('Priority')) {
                    $params.Add('priority', $Priority)
                }
                if ($PSBoundParameters.ContainsKey('LDAPAuthenticationPolicyName')) {
                    $params.Add('policy', $LDAPAuthenticationPolicyName)
                    _InvokeNSRestApi -Session $Session -Method PUT -Type vpnvserver_authenticationldappolicy_binding -Payload $params
                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerBinding -Session $Session -Name $Name -Binding LDAPAuthenticationPolicy -PolicyName $LDAPAuthenticationPolicyName
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('RADIUSAuthenticationPolicyName')) {
                    $params.Add('policy', $RADIUSAuthenticationPolicyName)
                    _InvokeNSRestApi -Session $Session -Method PUT -Type vpnvserver_authenticationradiuspolicy_binding -Payload $params
                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerBinding -Session $Session -Name $Name -Binding RADIUSAuthenticationPolicy -PolicyName $RADIUSAuthenticationPolicyName
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('SAMLAuthenticationPolicyName')) {
                    $params.Add('policy', $SAMLAuthenticationPolicyName)
                    _InvokeNSRestApi -Session $Session -Method PUT -Type vpnvserver_authenticationsamlpolicy_binding -Payload $params
                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerBinding -Session $Session -Name $Name -Binding RADIUSAuthenticationPolicy -PolicyName $RADIUSAuthenticationPolicyName
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('SessionPolicyName')) {
                    $params.Add('policy', $SessionPolicyName)
                    _InvokeNSRestApi -Session $Session -Method PUT -Type vpnvserver_vpnsessionpolicy_binding -Payload $params
                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerBinding -Session $Session -Name $Name -Binding SessionPolicy -PolicyName $SessionPolicyName
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('STAServer')) {
                    $params.Add('staserver', $STAServer)
                    _InvokeNSRestApi -Session $Session -Method PUT -Type vpnvserver_staserver_binding -Payload $params
                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerBinding -Session $Session -Name $Name -Binding STAServer -PolicyName $SessionPolicyName
                    }
                }
                elseif ($PSBoundParameters.ContainsKey('VPNUrlName')) {
                    $params.Add('urlname', $VPNUrlName)
                    _InvokeNSRestApi -Session $Session -Method PUT -Type vpnvserver_vpnurl_binding -Payload $params
                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSVPNVirtualServerBinding -Session $Session -Name $Name -Binding VPNUrl -PolicyName $VPNUrlName
                    }
                }
            }
            catch {
                throw $_
            }
        }
    }
}

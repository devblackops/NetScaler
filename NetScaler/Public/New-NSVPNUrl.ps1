<#
Copyright 2019 Iain Brighton

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

function New-NSVPNUrl {
    <#
    .SYNOPSIS
        Create NetScaler Gateway VPN url/bookmark resource.

    .DESCRIPTION
        Create NetScaler Gateway VPN url/bookmark resource.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the bookmark link.

        Minimum length = 1

    .PARAMETER DisplayName
        This setting determines whether the RDP parameters supplied in the vpn url override those specified in the RDP profile.
        
        Minimum length = 1

    .PARAMETER URL
       Web address for the bookmark link.
       
       Minimum length = 1

    .PARAMETER VirtualServer
        Name of the associated LB/CS vserver.

    .PARAMETER ClientlessAccess
        If clientless access to the resource hosting the link is allowed, also use clientless access for the bookmarked web address in the Secure Client Access based session. Allows single sign-on and other HTTP processing on NetScaler Gateway for HTTPS resources.
        
        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER Comment
        Any comments associated with the bookmark link.

    .PARAMETER IconUrl
        URL to fetch icon file for displaying this resource.

    .PARAMETER SSOType
        Single sign on type for unified gateway.
        
        Possible values = unifiedgateway, selfauth, samlauth

    .PARAMETER ApplicationType
        The type of application this VPN URL represents. Possible values are CVPN/SaaS/VPN.
        
        Possible values = CVPN, VPN, SaaS

    .PARAMETER SamlSSOProfile
        Profile to be used for doing SAML SSO.

    .PARAMETER Passthru
        Return the NetScaler Gateway VPN url/bookmark resource object.

    .PARAMETER Force
        Suppress confirmation when creating the NetScaler Gateway VPN url/bookmark resource.

    .EXAMPLE
        New-NSVPNUrl -Session $Session -Name 'MYRDPSERVER' -DisplayName 'MyRDPServer' -Url 'rdp://myrdpserver.domain.com' -ClientlessAccess 'ON'

        Creates a new NetScaler Gateway VPN RDP bookmark for the 'myrdpserver.domain.com' RDP server.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory)]
        [string] $Name,

        [parameter(Mandatory)]
        [string] $DisplayName,

        [parameter(Mandatory)]
        [string] $Url,

        [string] $VirtualServer,

        [ValidateSet('ON', 'OFF')]
        [string] $ClientlessAccess,

        [string] $Comment,

        [string] $IconUrl,

        [ValidateSet('UnifiedGateway', 'SelfAuth', 'SamlAuth')]
        [string] $SSOType,

        [ValidateSet('CVPN', 'VPN', 'SaaS')]
        [string] $ApplicationType,

        [string] $SamlSSOProfile,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force  -or $PSCmdlet.ShouldProcess($Name, "Add RDP client profile")) {
            try {
                $propertyMap = @{
                    DisplayName      = 'linkname'
                    Url              = 'actualurl'
                    VirtualServer    = 'vservername'
                    ClientlessAccess = 'clientlessaccess'
                    Comment          = 'comment'
                    IconUrl          = 'iconurl'
                    SSOType          = 'ssotype'
                    ApplicationType  = 'applicationtype'
                    SamlSSOProfile   = 'samlssoprofile'
                }
                $params = @{
                    name = $Name
                }

                foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
                    if ($propertyMap.ContainsKey($parameter.Key)) {
                        $params[$propertyMap[$parameter.Key]] = $parameter.Value
                    }
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type vpnurl -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSVPNUrl -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

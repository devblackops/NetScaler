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

function New-NSVPNSessionProfile {
    <#
    .SYNOPSIS
        Create NetScaler Gateway session profile resource.

    .DESCRIPTION
        Create NetScaler Gateway session profile resource.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the NetScaler Gateway profile (action). Must begin with an ASCII alphabetic or underscore (_) character, and must consist only of ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters. Cannot be changed after the profile is created. The following requirement applies only to the NetScaler CLI: If the name includes one or more spaces, enclose the name in double or single quotation marks (for example, "my action" or 'my action').

        Minimum length = 1

    .PARAMETER TransparentInterception
        Switch parameter. Allow access to network resources by using a single IP address and subnet mask or a range of IP addresses.
        When turned off,  sets the mode to proxy, in which you configure destination and source IP addresses and port numbers.
        If you are using the NetScale Gateway Plug-in for Windows, turn it on, in which the mode is set to transparent.
        If you are using the NetScale Gateway Plug-in for Java, turn it off.

    .PARAMETER SplitTunnel
        Send, through the tunnel, traffic only for intranet applications that are defined in NetScaler Gateway.
        Route all other traffic directly to the Internet.
        The OFF setting routes all traffic through Access Gateway.
        With the REVERSE setting, intranet applications define the network traffic that is not intercepted.All network traffic directed to internal IP addresses bypasses the VPN tunnel, while other traffic goes through Access Gateway.
        Reverse split tunneling can be used to log all non-local LAN traffic.

        Possible values: ON, OFF, REVERSE

    .PARAMETER DefaultAuthorizationAction
        Specify the network resources that users have access to when they log on to the internal network.

        Default value: DENY which deny access to all network resources.
        Possible values: ALLOW, DENY

    .PARAMETER SSO
        Set single sign-on (SSO) for the session. When the user accesses a server, the user's logon credentials are passed to the server for authentication.

        Possible values: ON, OFF

    .PARAMETER IcaProxy
        Enable ICA proxy to configure secure Internet access to servers running Citrix XenApp or XenDesktop by using Citrix Receiver instead of the Access Gateway Plug-in.

    .PARAMETER NtDomain
        Single sign-on domain to use for single sign-on to applications in the internal network.
        This setting can be overwritten by the domain that users specify at the time of logon or by the domain that the authentication server returns.

        Minimum length: 1
        Maximum length: 32

    .PARAMETER ClientlessVpnMode
        Enable clientless access for web, XenApp or XenDesktop, and FileShare resources without installing the Access Gateway Plug-in.
        Available settings function as follows: * ON - Allow only clientless access. * OFF - Allow clientless access after users log on with the Access Gateway Plug-in. * DISABLED - Do not allow clientless access.

    .PARAMETER ClientChoices
        Provide users with multiple logon options. With client choices, users have the option of logging on by using the Access Gateway Plug-in for Windows, Access Gateway Plug-in for Java, the Web Interface, or clientless access from one location.
        Depending on how Access Gateway is configured, users are presented with up to three icons for logon choices. The most common are the Access Gateway Plug-in for Windows, Web Interface, and clientless access.

    .PARAMETER StoreFrontUrl
        Web address for StoreFront to be used in this session for enumeration of resources from XenApp or XenDesktop.

    .PARAMETER WIHome
        Web address of the Web Interface server, such as http:///Citrix/XenApp, or Receiver for Web, which enumerates the virtualized resources, such as XenApp, XenDesktop, and cloud applications.

    .PARAMETER RDPClientProfileName
        Name of the RDP profile associated with the vserver.
        
        Minimum length = 1
        Maximum length = 31

    .PARAMETER PCOIPProfileName
        Name of the PCOIP profile associated with the session action. The builtin profile named none can be used to explicitly disable PCOIP for the session action.
        
        Minimum length = 1
        Maximum length = 31

    .PARAMETER Passthru
        Return the NetScaler Gateway session profile object.

    .PARAMETER Force
        Suppress confirmation when creating the NetScaler Gateway session profile.

    .EXAMPLE
        New-NSVPNSessionProfile -Session $Session -Name 'profile_receiver' -NTDomain 'lab.local' -WIHome "https://storefront.lab.local/Citrix/StoreWeb" -StoreFrontUrl "https://storefront.lab.local"

        Creates a new NetScaler Gateway session profile named 'profile_receiver'.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$Name,

        [ValidateSet("ON","OFF")]
        [string]$TransparentInterception,

        [ValidateSet("ON","OFF","REVERSE")]
        [string]$SplitTunnel,

        [ValidateSet("ALLOW","DENY")]
        [string]$DefaultAuthorizationAction,

        [ValidateSet("ON","OFF")]
        [string]$SSO,

        [ValidateSet("ON","OFF")]
        [string]$IcaProxy,

        [string]$NTDomain,

        [ValidateSet("ON","OFF","DISABLED")]
        [string]$ClientlessVpnMode="OFF",

        [ValidateSet("ON","OFF")]
        [string]$ClientChoices,

        [string]$StoreFrontUrl,

        [string]$WIHome,

        [ValidateLength(1, 31)]
        [string]$RDPClientProfileName,

        [ValidateLength(1, 31)]
        [string]$PCOIPProfileName,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($Name, 'Add NetScaler Gateway Session Profile')) {
            try {
                $params = @{
                    name = $Name
                }
                if ($PSBoundParameters.ContainsKey('TransparentInterception')) {
                    $params.Add('transparentinterception', $TransparentInterception)
                }
                if ($PSBoundParameters.ContainsKey('SplitTunnel')) {
                    $params.Add('splittunnel', $SplitTunnel)
                }
                if ($PSBoundParameters.ContainsKey('DefaultAuthorizationAction')) {
                    $params.Add('defaultauthorizationaction', $DefaultAuthorizationAction)
                }
                if ($PSBoundParameters.ContainsKey('SSO')) {
                    $params.Add('sso', $SSO)
                }
                if ($PSBoundParameters.ContainsKey('IcaProxy')) {
                    $params.Add('icaproxy', $IcaProxy)
                }
                if ($PSBoundParameters.ContainsKey('WIHome')) {
                    $params.Add('wihome', $WIHome)
                }
                if ($PSBoundParameters.ContainsKey('ClientChoices')) {
                    $params.Add('clientchoices', $ClientChoices)
                }
                if ($PSBoundParameters.ContainsKey('NTDomain')) {
                    $params.Add('ntdomain', $NTDomain)
                }
                if ($PSBoundParameters.ContainsKey('ClientlessVpnMode')) {
                    $params.Add('clientlessvpnmode', $ClientlessVpnMode)
                }
                if ($PSBoundParameters.ContainsKey('StoreFrontUrl')) {
                    $params.Add('storefronturl', $StoreFrontUrl)
                }
                if ($PSBoundParameters.ContainsKey('RDPClientProfileName')) {
                    $params.Add('rdpclientprofilename', $RDPClientProfileName)
                }
                if ($PSBoundParameters.ContainsKey('PCOIPProfileName')) {
                    $params.Add('pcoipprofilename', $PCOIPProfileName)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type vpnsessionaction -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSVPNSessionProfile -Session $Session -Name $Name
                }
            }
            catch
            {
                throw $_
            }
        }
    }
}

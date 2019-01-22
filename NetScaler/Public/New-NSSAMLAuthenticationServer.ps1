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

function New-NSSAMLAuthenticationServer {
    <#
    .SYNOPSIS
        Creates a new SAML authentication server object.

    .DESCRIPTION
        Creates a new SAML authentication server object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the SAML server profile .

    .PARAMETER SAMLIDPCertName
        Name of the SAML server as given in that servers SSL certificate.

    .PARAMETER SAMLSigningCertName
        Name of the signing authority as given in the SAML servers SSL certificate.

    .PARAMETER SAMLRedirectUrl
        URL to which users are redirected for authentication.

    .PARAMETER SAMLAcsIndex
        Index/ID of the metadata entry corresponding to this configuration.

        Default value: 255
        Minimum value = 0
        Maximum value = 255

    .PARAMETER SAMLUserField
        SAML user ID, as given in the SAML assertion.

    .PARAMETER SAMLRejectUnsignedAssertion
        Reject unsigned SAML assertions. ON option results in rejection of Assertion that is received without signature.
        STRICT option ensures that both Response and Assertion are signed. OFF allows unsigned Assertions.

        Default value: ON
        Possible values = ON, OFF, STRICT

    .PARAMETER SAMLIssuerName
        The name to be used in requests sent from Netscaler to IdP to uniquely identify Netscaler.

    .PARAMETER SAMLTwoFactor
        Option to enable second factor after SAML.

        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER DefaultAuthenticationGroup
        This is the default group that is chosen when the authentication succeeds in addition to extracted groups.

    .PARAMETER SignatureAlgorithm
        Algorithm to be used to sign/verify SAML transactions.

        Default value: RSA-SHA1
        Possible values = RSA-SHA1, RSA-SHA256

    .PARAMETER DigestMethod
        Algorithm to be used to compute/verify digest for SAML transactions.

        Default value: SHA1
        Possible values = SHA1, SHA256

    .PARAMETER RequestedAuthenticationContext
        This element specifies the authentication context requirements of authentication statements returned in the response.

        Default value: Exact
        Possible values = Exact, Minimum, Maximum, Better

    .PARAMETER AuthenticationClassType
        This element specifies the authentication class types that are requested from IdP (IdentityProvider).

    .PARAMETER SAMLBinding
        This element specifies the transport mechanism of saml messages.

        Default value: POST
        Possible values = REDIRECT, POST, ARTIFACT

    .PARAMETER AttributeConsumingServiceIndex
        Index/ID of the attribute specification at Identity Provider (IdP). IdP will locate attributes requested by SP using this index and send those attributes in Assertion.

        Default value: 255
        Minimum value = 0
        Maximum value = 255

    .PARAMETER SendThumbprint
        Option to send thumbprint instead of x509 certificate in SAML request.

        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER EnforceUsername
        Option to choose whether the username that is extracted from SAML assertion can be edited in login page while doing second factor.

        Default value: ON
        Possible values = ON, OFF

    .PARAMETER LogoutUrl
        SingleLogout URL on IdP to which logoutRequest will be sent on Netscaler session cleanup.

    .PARAMETER ArtifactResolutionServiceUrl
        URL of the Artifact Resolution Service on IdP to which Netscaler will post artifact to get actual SAML token.

    .PARAMETER SkewTime
        This option specifies the allowed clock skew in number of minutes that Netscaler ServiceProvider allows on an incoming assertion.
        For example, if skewTime is 10, then assertion would be valid from (current time - 10) min to (current time + 10) min, ie 20min in all.

        Default value: 5

    .PARAMETER LogoutBinding
        This element specifies the transport mechanism of saml logout messages.

        Default value: POST
        Possible values = REDIRECT, POST

    .PARAMETER ForceAuthentication
        Option that forces authentication at the Identity Provider (IdP) that receives Netscalers request.

        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER Force
        Suppress confirmation when creating the SAML authentication server object.

    .PARAMETER Passthru
        Return the SAML authentication server object.

    .EXAMPLE
        New-NSSAMLAuthenticationServer -Name 'saml_sso' -SAMLIDPCertName 'sso.provider.com' - SAMLRedirectUrl 'https://sso.provider.com/idp/SAMLfederation' -SAMLUserField 'NameID'

        Creates a new SAML authentication server with the name 'saml_sso'
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', DefaultParameterSetName = 'IPAddress')]
    param (
        $Session = $Script:Session,

        [parameter(Mandatory)]
        [string] $Name,

        [string] $SAMLIDPCertName,

        [string] $SAMLSigningCertName,

        [string] $SAMLRedirectUrl,

        [ValidateRange(0, 255)]
        [int] $SAMLAcsIndex,

        [string] $SAMLUserField,

        [ValidateSet('ON','OFF','STRICT')]
        [string] $SAMLRejectUnsignedAssertion,

        [string] $SAMLIssuerName,

        [ValidateSet('ON','OFF')]
        [string] $SAMLTwoFactor,

        [string] $DefaultAuthenticationGroup,

        [ValidateSet('RSA-SHA1','RSA-SHA256')]
        [string] $SignatureAlgorithm,

        [ValidateSet('SHA1','SHA256')]
        [string] $DigestMethod,

        [ValidateSet('Exact','Minimum','Maximum','Better')]
        [string] $RequestedAuthenticationContext,

        [ValidateSet('InternetProtocol','InternetProtocolPassword','Kerberos','MobileOneFactorUnregistered',
                     'MobileTwoFactorUnregistered','MobileOneFactorContract','MobileTwoFactorContract','Password',
                     'PasswordProtectedTransport','PreviousSession','X509','PGP','SPKI','XMLDSig','Smartcard',
                     'SmartcardPKI','SoftwarePKI','Telephony','NomadTelephony','PersonalTelephony',
                     'AuthenticatedTelephony','SecureRemotePassword','TLSClient','TimeSyncToken','Unspecified',
                     'Windows')]
        [string[]] $AuthenticationClassType,

        [string] $SAMLBinding,

        [int] $AttributeConsumingServiceIndex,

        [ValidateSet('ON','OFF')]
        [string] $SendThumbprint,

        [ValidateSet('ON','OFF')]
        [string] $EnforceUsername,

        [string] $LogoutUrl,

        [string] $ArtifactResolutionServiceUrl,

        [int] $SkewTime,

        [ValidateSet('REDIRECT','POST')]
        [string] $LogoutBinding,

        [ValidateSet('ON', 'OFF')]
        [string] $ForceAuthentication,

        [switch] $Force,

        [switch] $PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force  -or $PSCmdlet.ShouldProcess($Name, "Add SAML authentication server")) {
            try {
                $propertyMap = @{
                    SAMLIDPCertName                = 'samlidpcertname'
                    SAMLSigningCertName            = 'samlsigningcertname'
                    SAMLRedirectUrl                = 'samlredirecturl'
                    SAMLAcsIndex                   = 'samlacsindex'
                    SAMLUserField                  = 'samluserfield'
                    SAMLRejectUnsignedAssertion    = 'samlrejectunsignedassertion'
                    SAMLIssuerName                 = 'samlissuername'
                    SAMLTwoFactor                  = 'samltwofactor'
                    DefaultAuthenticationGroup     = 'defaultauthenticationgroup'
                    SignatureAlgorithm             = 'signaturealg'
                    DigestMethod                   = 'digestmethod'
                    RequestedAuthenticationContext = 'requestedauthncontext'
                    AuthenticationClassType        = 'authnctxclassref'
                    SAMLBinding                    = 'samlbinding'
                    AttributeConsumingServiceIndex = 'attributeconsumingserviceindex'
                    SendThumbprint                 = 'sendthumbprint'
                    EnforceUsername                = 'enforceusername'
                    LogoutUrl                      = 'logouturl'
                    ArtifactResolutionServiceUrl   = 'artifactresolutionserviceurl'
                    SkewTime                       = 'skewtime'
                    LogoutBinding                  = 'logoutbinding'
                    ForceAuthentication            = 'forceauthn'
                }
                $params = @{
                    name = $Name
                }

                foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
                    if ($propertyMap.ContainsKey($parameter.Key)) {
                        $params[$propertyMap[$parameter.Key]] = $parameter.Value
                    }
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type authenticationsamlaction -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSSAMLAuthenticationServer -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

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

function New-NSSSLProfile {
    <#
    .SYNOPSIS
        Creates a new SSL profile.

    .DESCRIPTION
        Creates a new SSL profile.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the SSL profile

    .PARAMETER SSL2
        State of SSLv2 protocol support for the SSL profile.

        Default value: DISABLED

    .PARAMETER SSL3
        State of SSLv3 protocol support for the SSL profile.

        Default value: ENABLED

    .PARAMETER TLS1
        State of TLSv1.0 protocol support for the SSL profile.

        Default value: ENABLED

    .PARAMETER TLS11
        State of TLSv1.1 protocol support for the SSL profile.

        Default value: ENABLED

    .PARAMETER TLS12
        State of TLSv1.2 protocol support for the SSL profile.

        Default value: ENABLED

    .PARAMETER DenySslRenegotiation
        Deny renegotiation in specified circumstances.

        Default value: All

    .PARAMETER DH
        State of Diffie-Hellman (DH) key exchange.

        Default value: DISABLED

    .PARAMETER DHFile
        Name of and, optionally, path to the DH parameter file, in PEM format, to be installed. /nsconfig/ssl/ is the default path.

    .PARAMETER DHCount
        Number of interactions, between the client and the NetScaler appliance, after which the DH private-public pair is regenerated. A value of zero (0) specifies infinite use (no refresh).

    .PARAMETER DHKeyExpSizeLimit
        This option enables the use of NIST recommended (NIST Special Publication 800-56A) bit size for private-key size. For example, for DH params of size 2048bit, the private-key size recommended is 224bits. This is rounded-up to 256bits.

        Default value: DISABLED

    .PARAMETER ProfileType
        Type of profile. Front end profiles apply to the entity that receives requests from a client. Backend profiles apply to the entity that sends client requests to a server.
        Default value: FrontEnd

    .PARAMETER DenySslRenegotiation
        Deny renegotiation in specified circumstances. Available settings function as follows: * NO - Allow SSL renegotiation. * FRONTEND_CLIENT - Deny secure and nonsecure SSL renegotiation initiated by the client. * FRONTEND_CLIENTSERVER - Deny secure and nonsecure SSL renegotiation initiated by the client or the NetScaler during policy-based client authentication. * ALL - Deny all secure and nonsecure SSL renegotiation. * NONSECURE - Deny nonsecure SSL renegotiation. Allows only clients that support RFC 5746.
        Default value: ALL
        Possible values = NO, FRONTEND_CLIENT, FRONTEND_CLIENTSERVER, ALL, NONSECURE

    .EXAMPLE
        New-NSSSLProfile -Name "Secure_SSL_Profile" -ProfileType "FrontEnd" -SSL3 $false -TLS1 $true -TLS11 $true -TLS12 $true -DenySslRenegotiation "FRONTEND_CLIENT"

        Creates a new SSL profile named 'Secure_SSL_Profile'.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [String]$Name,

        [ValidateSet('NO','FRONTEND_CLIENT','FRONTENT_CLIENTSERVER','ALL','NONSECURE')]
        [string]$DenySslRenegotiation,

        [ValidateSet('FrontEnd','BackEnd')]
        [string]$ProfileType,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$SSL3,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$TLS1,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$TLS11,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$TLS12,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$DH,

        [string]$DHFile,

        [ValidateRange(0,65534)]
        [int]$DHCount,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$DHKeyExpSizeLimit,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Create SSL Profile')) {
            try {
                $params = @{
                    name = $Name
                }
                if ($PSBoundParameters.ContainsKey('DenySslRenegotiation')) {
                    $params.Add('denysslreneg', $DenySslRenegotiation)
                }
                if ($PSBoundParameters.ContainsKey('SSL3')) {
                    $params.Add('ssl3', $SSL3)
                }
                if ($PSBoundParameters.ContainsKey('TLS1')) {
                    $params.Add('tls1', $TLS1)
                }
                if ($PSBoundParameters.ContainsKey('TLS11')) {
                    $params.Add('tls11', $TLS11)
                }
                if ($PSBoundParameters.ContainsKey('TLS12')) {
                    $params.Add('tls12', $TLS12)
                }
                if ($PSBoundParameters.ContainsKey('DH')) {
                    $params.Add('dh', $DH)
                }
                if ($PSBoundParameters.ContainsKey('DHFile')) {
                    $params.Add('dhfile', $DHFile)
                }
                if ($PSBoundParameters.ContainsKey('DHCount')) {
                    $params.Add('dhcount', $DHCount)
                }
                if ($PSBoundParameters.ContainsKey('DHKeyExpSizeLimit')) {
                    $params.Add('dhkeyexpsizelimit', $DHKeyExpSizeLimit)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type sslprofile -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return (Get-NSSSLProfile -Session $session -Name $Name)
                }
            }
            catch {
                throw $_
            }
        }
    }
}

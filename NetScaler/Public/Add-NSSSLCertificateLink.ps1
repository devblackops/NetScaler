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

function Add-NSSSLCertificateLink {
    <#
    .SYNOPSIS
        Add a SSL certificate link to an intermediate certificate.

    .DESCRIPTION
        Add a SSL certificate link to an intermediate certificate.

    .EXAMPLE
        Add-NSSSLCertificateLink -CertKeyName 'mycert' -IntermediateCertKeyName 'myCAcert'

        Links the 'mycert' certificate key pair to the issuing 'myCAcert' issuing root certificate key pair.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertKeyName
        Name of the certificate key pair to add the link to.

    .PARAMETER IntermediateCertKeyName
        The certificate key pair name of the intermediate certificate/CA to link.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [string]$CertKeyName,

        [Parameter(Mandatory)]
        [string]$IntermediateCertKeyName
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($CertKeyName, 'Add SSL certificate link')) {
            try {
                 $params = @{
                    certkey = $CertKeyName
                    linkcertkeyname = $IntermediateCertKeyName
                }
                _InvokeNSRestApi -Session $Session -Method POST -Type sslcertkey -Payload $params -Action link | Out-Null
            }
            catch {
                throw $_
            }
        }
    }
}

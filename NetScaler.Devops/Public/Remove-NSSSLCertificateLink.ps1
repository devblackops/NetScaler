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

function Remove-NSSSLCertificateLink {
    <#
    .SYNOPSIS
        Removes a SSL certificate link from an intermediate certificate.

    .DESCRIPTION
        Removes a SSL certificate link from an intermediate certificate.

    .EXAMPLE
        Remove-NSSSLCertificateLink -CertKeyName 'mycert'

        Deletes associated/chained certificates linked to the 'mycert' key pair.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertKeyName
        Name of the certificate key pair to add the link to.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [string]$CertKeyName
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($CertKeyName, 'Delete SSL certificate link')) {
            try {
                $params = @{
                    certkey = $CertKeyName
                }
                _InvokeNSRestApi -Session $Session -Method POST -Type sslcertkey -Payload $params -Action unlink > $null
            }
            catch {
                throw $_
            }
        }
    }
}

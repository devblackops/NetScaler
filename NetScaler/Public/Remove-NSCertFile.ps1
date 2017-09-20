<#
Copyright 2017 Juan C. Herrera

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

function Remove-NSCertFile {
    <#
    .SYNOPSIS
        Add server certificate to NetScaler appliance.

    .DESCRIPTION
        Add server certificate to NetScaler appliance.

    .EXAMPLE
        Add-NSCertKeyPair -CertKeyName 'myrootCA' -CertPath '/nsconfig/ssl/mycertificate.cert' -CertKeyFormat 'PEM'

        Creates a root certificate key pair named 'myrootCA' using the PEM formatted certificate 'mycertificate.cert' located on the appliance.

    .EXAMPLE
        Add-NSCertKeyPair -CertKeyName 'mywildcardcert' -CertPath '/nsconfig/ssl/mywildcard.cert' -KeyPath '/nsconfig/ssl/mywildcard.key' -CertKeyFormat 'PEM'

        Creates a certificate key pair named 'mywildardcert' using the PEM formatted certificate 'mywildcard.cert' and 'mywildcard.key' key file located on the appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertName
        Name to assign to the imported certificate file. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters. The following requirement applies only to the NetScaler CLI: If the name includes one or more spaces, enclose the name in double or single quotation marks (for example, "my file" or 'my file').
        Minimum length = 1
        Maximum length = 31
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter()]
        [string[]]$CertName
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $CertName) {
            if ($PSCmdlet.ShouldProcess($item, 'Remove imported certificate')) {
                try {
                    $params = @{
                        name = $CertName
                    }
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type sslcertfile -Resource $item -Arguments $params -Action delete

                } catch {
                    throw $_
                }
            }
        }
    }
}

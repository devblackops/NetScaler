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

function Get-NSSSLCertificateLink {
    <#
    .SYNOPSIS
        Get a SSL certificate link.

    .DESCRIPTION
        Get a SSL certificate link.

    .EXAMPLE
        Get-NSSSLCertificateLink

        Get all SSL certificate links

    .EXAMPLE
        Get-NSSSLCertificateLink -Name 'mycertkey'

        Get linked certificates for the SSL certificate key pair 'mycertkey'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertKeyName
        Name of the certificate key pair to add the link to.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter()]
        [string]$CertKeyName
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            $Filters = @{ }
            if ($PSBoundParameters.ContainsKey('CertKeyName')) {
                $Filters.Add('certkeyname', $CertKeyName)
            }
            _InvokeNSRestApiGet -Session $Session -Type sslcertlink -Filters $Filters
        }
        catch {
            throw $_
        }
    }
}

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

function Get-NSCertKeyPair {
    <#
    .SYNOPSIS
        Retrieve server certificate from NetScaler appliance.

    .DESCRIPTION
        Retrieve server certificate from NetScaler appliance.

    .EXAMPLE
        Get-NSCertKeyPair -CertKeyName 'myrootCA'

        Retrieves a root certificate key pair named 'myrootCA' located on the appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertKeyName
        Name for the certificate and private-key pair. Must begin with an ASCII alphanumeric or underscore (_) character,
        and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=),
        and hyphen (-) characters. Cannot be changed after the certificate-key pair is created. The following requirement
        applies only to the NetScaler CLI: If the name includes one or more spaces, enclose the name in double or single
        quotation marks (for example, "my cert" or 'my cert').
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
        if ($PSCmdlet.ShouldProcess($CertKeyName, 'Retrieve SSL certificate and private key pair')) {
            try {
                $response = _InvokeNSRestApi -Session $Session -Method GET -Type sslcertkey -Resource $CertKeyName -Action get
                $response.sslcertkey
            } catch {
                throw $_
            }
        }
    }
}
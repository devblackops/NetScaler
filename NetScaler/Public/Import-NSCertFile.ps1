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

function Import-NSCertFile {
    <#
    .SYNOPSIS
        Add server certificate to NetScaler appliance.

    .DESCRIPTION
        Add server certificate to NetScaler appliance.

    .EXAMPLE
        Import-NSCertFile -CertName somecert.pem -Location 'http://website.local/certs/somecert.pem'

        Imports  the appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CertName
        Name to assign to the imported certificate file. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters. The following requirement applies only to the NetScaler CLI: If the name includes one or more spaces, enclose the name in double or single quotation marks (for example, "my file" or 'my file').
        Minimum length = 1
        Maximum length = 31

    .PARAMETER Location
        URL specifying the protocol, host, and path, including file name, to the certificate file to be imported. For example, http://www.example.com/cert_file. NOTE: The import fails if the object to be imported is on an HTTPS server that requires client certificate authentication for access.
        Minimum length = 1
        Maximum length = 2047
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter()]
        [string]$CertName,

        [Parameter()]
        [string]$Location
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($CertName, 'Import SSL certificate')) {
            try {
                 $params = @{
                    name = $CertName
                    src = $Location
                }
                $response = _InvokeNSRestApi -Session $Session -Method POST -Type sslcertfile -Payload $params -Action import
            } catch {
                throw $_
            }
        }
    }
}

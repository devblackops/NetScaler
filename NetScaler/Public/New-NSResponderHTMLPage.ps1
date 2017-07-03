<#
Copyright 2015 Brandon Olin

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

function New-NSResponderHTMLPage {
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

    .PARAMETER Name
        Name to assign to the HTML page object on the NetScaler appliance.
        Minimum length = 1
        Maximum length = 31
        
    .PARAMETER Source
        Local path to and name of, or URL \(protocol, host, path, and file name\) for, the file in which to store the imported HTML page. NOTE: The import fails if the object to be imported is on an HTTPS server that requires client certificate authentication for access.
        Minimum length = 1
        Maximum length = 2047

    .PARAMETER Comment
        Any comments to preserve information about the HTML page object.
        Maximum length = 128

    .PARAMETER Overwrite
        Overwrites the existing file.
    #>

    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Source,

        [Parameter()]
        [string]$Comment,

        [Parameter()]
        [switch]$Overwrite = $false
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Add a HTML Responder page')) {
            try {
                 $params = @{
                    src = $Source
                    name = $Name
                    comment = $Comment
                    overwrite = $Overwrite.ToBool()
                }
                $response = _InvokeNSRestApi  -Session $Session -Method POST -Type responderhtmlpage -Payload $params -Action import
            } catch {
                throw $_
            }
        }
    }
}

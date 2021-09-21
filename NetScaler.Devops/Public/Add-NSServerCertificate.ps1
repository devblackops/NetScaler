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

function Add-NSServerCertificate {
    <#
    .SYNOPSIS
        Add server certificate to NetScaler appliance.

    .DESCRIPTION
        Add server certificate to NetScaler appliance.

    .EXAMPLE
        Add-NSServerCertificate -CAName 'webserver.example.com' -CommonName 'storefront.example.com' -OrganizationName 'My Company, Inc.' -CountryName "US" -StateName "Oregon" -KeyFileBits "2048"

        Adds a new 2048 bit certificate with common name 'storefront.example.com' to the NetScaler. 

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER CAName
        The FQDN of the Certificate Authority host and Certificate Authority
        name in the form CAHostNameFQDN\CAName

    .PARAMETER CATemplate
        Certificate template name on Certificate Authority host to use when requesting certificate.

    .PARAMETER CommonName
        Fully qualified domain name for the company or web site.

    .PARAMETER OrganizationName
        Name of the organization that will use this certificate.

    .PARAMETER CountryName
        Two letter ISO code for your country. For example, US for United States.

    .PARAMETER StateName
        Full name of the state or province where your organization is located. Do not abbreviate.

    .PARAMETER KeyFileBits
        Size, in bits, of the private key.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [string]$CAName,

        [Parameter(Mandatory)]
        [string]$CATemplate,

        [Parameter(Mandatory)]
        [ValidateLength(1,63)]
        [string]$CommonName,

        [Parameter(Mandatory)]
        [ValidateLength(1,63)]
        [string]$OrganizationName,

        [Parameter(Mandatory)]
        [ValidateLength(2,2)]
        [string]$CountryName,

        [Parameter(Mandatory)]
        [ValidateLength(1,127)]
        [string]$StateName,

        [ValidateRange(512,4096)]
        [int]$KeyFileBits = 2048
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($CommonName, 'Add server certificate')) {
            $fileName = $CommonName -replace "\*","wildcard"
            $certKeyFileName= "$($fileName).key"
            $certReqFileName = "$($fileName).req"
            $certFileName = "$($fileName).cert"

            # Temp files
            $certReqFileFull = "$($env:TEMP)\$certReqFileName"
            $certFileFull = "$($env:TEMP)\$certFileName"

            try {
                Write-Verbose -Message "Creating RSA key file for: $CommonName"
                $privKeyResp = Add-NSRSAKey -Session $session -Name $certKeyFileName -KeyFileBits $keyFileBits -PassThru -Force
                if ($privKeyResp.errorcode -ne 0) { throw $privKeyResp }

                Write-Verbose -Message 'Creating certificate request'
                $csrParams = @{
                    reqfile = $certReqFileName
                    keyfile = $certKeyFileName
                    commonname = $CommonName
                    organizationname = $OrganizationName
                    countryname = $CountryName
                    statename = $StateName
                }
                _InvokeNSRestApi -Session $Session -Method POST -Type sslcertreq -Payload $csrParams -Action create

                Write-Verbose -Message 'Downloading certificate request'
                $downloadParams = @{
                    filelocation = "/nsconfig/ssl"
                }
                $response = _InvokeNSRestApi -Session $Session -Method GET -Type systemfile -Resource $certReqFileName -Arguments $downloadParams
                if (-not [String]::IsNullOrEmpty($response.systemfile.filecontent)) {
                    $certReqContentBase64 = $response.systemfile.filecontent
                } else {
                    throw "Certificate request file content returned empty"
                }
                $certReqContent = [System.Convert]::FromBase64String($certReqContentBase64)
                $certReqContent | Set-Content $certReqFileFull -Encoding Byte -Force

                Write-Verbose -Message "Requesting certificate for CN: $CommonName"
                certreq.exe -Submit -q -attrib "CertificateTemplate:$CATemplate" -config $CAName $certReqFileFull $certFileFull
                if (-not $? -or $LASTEXITCODE -ne 0) {
                    throw "certreq.exe failed to request certificate"
                }

                Write-Verbose -Message 'Uploading certificate'
                if (Test-Path -Path  $certFileFull) {
                    $certContent = Get-Content -Path $certFileFull -Encoding "Byte"
                    $certContentBase64 = [System.Convert]::ToBase64String($certContent)

                    $certUploadParams = @{
                        filename = $certFileName
                        filecontent = $certContentBase64
                        filelocation = '/nsconfig/ssl/'
                        fileencoding = 'BASE64'
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type systemfile -Payload $certUploadParams -Action add

                    Write-Verbose -Message 'Creating certificate request'
                    Add-NSCertKeyPair -Session $Session -CertKeyName $fileName -CertPath $certFileName -KeyPath $certKeyFileName
                } else {
                    throw "Cert file '$certFileFull' not found."
                }
            catch {
                throw $_
            }
            } finally {
                Write-Verbose -Message 'Cleaning up local temp files'
                Remove-Item -Path "$env:TEMP\$CommonName.*" -Force
            }
        }
    }
}
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

function Add-NSRSAKey {
    <#
    .SYNOPSIS
        Create a new RSA private key on the NetScaler appliance.

    .DESCRIPTION
        Create a new RSA private key on the NetScaler appliance.

    .EXAMPLE
        Add-NSRSAKey -Name 'DC.EXAMPLE.COM\EXAMPLE-DC-CA'

        Add a new RSA private key with name 'DC.EXAMPLE.COM\EXAMPLE-DC-CA'

    .EXAMPLE
        $result = Add-NSRSAKey -Name 'DC.EXAMPLE.COM\EXAMPLE-DC-CA' -KeyFileBits 4096 -PassThru

        Add a new 4096 bit RSA private key with name 'DC.EXAMPLE.COM\EXAMPLE-DC-CA' and return the newly created key.

    .EXAMPLE
        $names = 'dc.example.com\example-dc-ca1', 'dc.example.com\example-dc-ca2'
        $names | Add-NSRSAKey -KeyFileBits = 2048

        Add a new 2048 bit RSA private key using the pipeline.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The FQDN of the Certification Authority host and Certification Authority
        name in the form CAHostNameFQDN\CAName

        Maximum length = 63

    .PARAMETER KeyFileBits
        Size, in bits, of the RSA key.

        Default value = 2048
        Minimum value = 512
        Maximum value = 4096

    .PARAMETER Passthru
        Return the newly created private key.

    .PARAMETER Force
        Suppress confirmation when creating RSA key.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [ValidateLength(1, 63)]
        [string[]]$Name,

        [ValidateRange(512,4096)]
        [int]$KeyFileBits = 2048,

        [switch]$PassThru,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            $fileName = $item -replace "\*","wildcard"
            $certKeyFileName= "$($fileName).key"
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Add RSA private key')) {
                $params = @{
                    keyfile = $certKeyFileName
                    bits = $KeyFileBits
                }
                $response = _InvokeNSRestApi -Session $Session -Method POST -Type sslrsakey -Payload $params -Action create

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return $response
                }
            }
        }
    }
}
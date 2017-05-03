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

function Remove-NSCertKeyPair {
    <#
    .SYNOPSIS
        Remove server certificate from NetScaler appliance.

    .DESCRIPTION
        Remove server certificate from NetScaler appliance.

    .EXAMPLE
        Remove-NSCertKeyPair -CertKeyName 'myrootCA'

        Removes a root certificate key pair named 'myrootCA' from the appliance.
    
    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Force
    Suppress confirmation removing certificate binding
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter()]
        [string]$CertKeyName,

        [Switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $CertKeyName) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Remove certificate')) {
                try {

                    _InvokeNSRestApi -Session $Session -Method DELETE -Type sslcertkey -Resource $item -Action delete

                } catch {
                    throw $_
                }
            }
        }
    }
}
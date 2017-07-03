<#
Copyright 2017 Juan Herrera

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

function Get-NSResponderHTMLPage {
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
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter()]
        [string]$Name
    )

    begin {
        _AssertSessionActive
    }

#     process {
#         if ($PSCmdlet.ShouldProcess($Name, 'Add a HTML Responder page')) {
#             try {
#                  $params = @{
#                     name = $Name
#                 }
#                 $response = _InvokeNSRestApi  -Session $Session -Method GET -Type responderhtmlpage -Payload $params -Action get
#             } catch {
#                 throw $_
#             }
#         }
#     }
# }


    process {
        # Contruct a filter hash if we specified any filters
        # $Filters = @{}
        # if ($PSBoundParameters.ContainsKey('Name')) {
        #     $Filters['name'] = $Name
        # }
        _InvokeNSRestApiGet -Session $Session -Type responderhtmlpage -Name $Name #-Filters $Filters
    }
}
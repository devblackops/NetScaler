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

function Get-NSResponderHTMLPage {
    <#
    .SYNOPSIS
        Retrieve a responder HTML page from the NetScaler appliance.

    .DESCRIPTION
        Retrieve a responder HTML page from the NetScaler appliance.

    .EXAMPLE
        Get-NSResponderHTMLPage -Name 'myHTMLpage'

        Creates a root certificate key pair named 'myrootCA' using the PEM formatted certificate 'mycertificate.cert' located on the appliance.

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

    process {
        $response = _InvokeNSRestApiGet -Session $Session -Type responderhtmlpage -Name $Name
        if (!$response) { $response.name }
    }
}
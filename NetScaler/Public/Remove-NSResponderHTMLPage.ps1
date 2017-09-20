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

function Remove-NSResponderHTMLPage {
    <#
    .SYNOPSIS
        Removes a responder HTML page from the NetScaler appliance.

    .DESCRIPTION
        Removes a responder HTML page from the NetScaler appliance.

    .EXAMPLE
        Remove-NSResponderHTMLPage -Name 'myHTMLpage'

        Removes a Responder Policy HTML page from the appliance.

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
        [string]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete ResponderHTML Page')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type responderhtmlpage -Resource $item -Action DELETE
                } catch {
                    throw $_
                }
            }
        }
    }
}
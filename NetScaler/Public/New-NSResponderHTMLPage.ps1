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
        Add Responder HTML page to NetScaler appliance.

    .DESCRIPTION
        Add Responder HTML page to NetScaler appliance.

    .EXAMPLE
        New-NSResponderHTMLPage -Name 'myrootCA' -Source 'http://somewebsite.com/somefile' -Comment 'Application XYZ page'

        Creates a Responder HTML page sourcing from a repo named 'http://somewebsite.com/somefile' into the appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name to assign to the HTML page object on the NetScaler appliance.
        Minimum length = 1
        Maximum length = 31

    .PARAMETER Source
        Local path to and name of, or URL \(protocol, host, path, and file name\) for, the file in which to store the imported HTML page. NOTE: The import fails if the object to be imported is on an HTTPS server that requires client certificate authentication for access. Also, check any firewall rules in between source and destination.
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
                    overwrite = $Overwrite.ToBool()
                }
                $response = _InvokeNSRestApi  -Session $Session -Method POST -Type responderhtmlpage -Payload $params -Action import
            } catch {
                throw $_
            }
        }
    }
}

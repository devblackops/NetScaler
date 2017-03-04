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

function Install-NSLicense {
    <#
    .SYNOPSIS
        Uploads and installs license file(s) to NetScaler appliance

    .DESCRIPTION
        Uploads and installs license file(s) to NetScaler appliance

    .EXAMPLE
        Install-NSLicense -Session $session -Path .\license.lic

        Install the license file named 'license.lic' in the current directory.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Path
        The path to the license file.

    .PARAMETER PassThru
        Return the license object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='medium')]
    param(
        [parameter(Mandatory)]
        $Session = $script:session,
        
        [parameter(Mandatory)]
        [ValidateScript({
            if (Test-Path -Path $_) {
                $true
            } else {
                throw 'Cannot find license file. Path does not exist.'
            }
        })]
        [string]$Path,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            $fileName = Split-Path -Path $Path -Leaf
            if (-not $fileName.EndsWith(".lic", [StringComparison]::OrdinalIgnoreCase)) {
                throw "'$fileName' file name is invalid. Valid Citrix license file names end in .lic."
            }

            if ($PSCmdlet.ShouldProcess($fileName, 'Install license file')) {
                $licContent = Get-Content -Path $Path -Encoding "Byte"
                $licContentBase64 = [System.Convert]::ToBase64String($licContent)
                $params = @{
                    filename = $fileName
                    filecontent = $licContentBase64
                    filelocation = '/nsconfig/license/'
                    fileencoding = 'BASE64'
                }
                $response = _InvokeNSRestApi -Session $Session -Method POST -Type systemfile systemfile -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                   return $response 
                }
            }
        } catch {
            throw $_
        }
    }
}
<#
Copyright 2016 Dominique Broeglin

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

function Add-NSSystemFile {
    <#
    .SYNOPSIS
        Add a file on the given location on the NetScaler appliance.

    .DESCRIPTION
        Add a file on the given location on the NetScaler appliance.

    .EXAMPLE
        Add-NSSystemFile -Path '/tmp/aaa.extlab.local.pfx -FileLocation '/nsconfig/ssl' -Filename 'aaa.extlab.local.pfx'

        Adds the local '/tmp/aaa.extlab.local.pfx' to the certificate directory on the
        NetScaler appliance under the name 'aaa.extlab.local.pfx'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Path
        Local path of the file to upload to the NetScaler appliance.

    .PARAMETER FileLocation
        Path of the directory, on the NetScaler appliance, where the file will be uploaded.

    .PARAMETER Filename
        Name of the file once it is uploaded on the NetScaler appliance.

    .PARAMETER Force
        Suppress confirmation when creating the system file (this does not override a
        pre-existing file).

    .NOTES
        Nitro implementation status: partial
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:Session,

        [parameter(Mandatory)]
        [String]$Path,

        [parameter(Mandatory)]
        [String]$FileLocation,

        [parameter(Mandatory)]
        [String]$Filename,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        $FileName = Split-Path -Path $FileName -Leaf
        if ($Force -or $PSCmdlet.ShouldProcess($Path, 'Add system file')) {
            try {
                $certContent = Get-Content -Path $Path -Encoding "Byte"
                $certContentBase64 = [System.Convert]::ToBase64String($certContent)
                $params = @{
                    filename = $FileName
                    filecontent = $certContentBase64
                    filelocation = $FileLocation
                    fileencoding = 'BASE64'
                }
                _InvokeNSRestApi -Session $Session -Method POST -Type systemfile systemfile -Payload $params -Action add
            } catch {
                throw $_
            }
        }
    }
}

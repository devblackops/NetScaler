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

function Remove-NSSystemFile {
    <#
    .SYNOPSIS
        Removes the specified system file object(s).

    .DESCRIPTION
        Removes the specified system file object(s).

    .EXAMPLE
        Get-NSSystemFile -Filename "foo.txt" -FileLocation "/foo/bar"
    
        Removes the file "/foo/bar/foo.txt"

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Filename
        Name of the file.

    .PARAMETER FileLocation
        Location of the file.

    .PARAMETER Force
        Suppress confirmation when deleting the file.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $Script:Session,

        [Parameter(Mandatory)]
        [string]$Filename,

        [Parameter(Mandatory)]
        [string]$FileLocation,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        $fileFullPath = "$FileLocation/$Filename"
        if ($Force -or $PSCmdlet.ShouldProcess($fileFullPath, "Remove file")) {
            $Arguments = @{ 'filename' = $Filename; 'filelocation' = $FileLocation }
            _InvokeNSRestApi -Session $Session -Type systemfile -Arguments $Arguments -Method DELETE
        }
    }
}

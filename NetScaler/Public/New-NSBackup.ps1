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

function New-NSBackup {
    <#
    .SYNOPSIS
        Create a backup of the NetScaler configuration.        

    .DESCRIPTION
        Create a backup of the NetScaler configuration.

    .EXAMPLE
        New-NSBackup -Filename 'test' -Level 'full' -Comment 'Before upgrade'
        
        Creates a full backup of the NetScaler configuration called 'test.tgz'
    .EXAMPLE
        $backup = New-NSBackup -Filename 'test' -Level 'full' -Comment 'Before upgrade' -PassThru
        $bytes = [System.Convert]::FromBase64String($backup.filecontent)
        [IO.File]::WriteAllBytes('c:\temp\test.tgz', $bytes)

        Creates a full backup of the NetScaler configuration called 'test.tgz' and then downloads
        the backup object and writes to disk.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Filename
        Name of the backup file.

        The file extension ".tgz" will be appended to the name automatically.

    .PARAMETER LEVEL
        The level of data to be backed up.

        Default value: basic
        Possible values = basic, full        

    .PARAMETER Comment
        Comment specified at the time of creation of the backup .

    .PARAMETER Passthru
        Download the backup file object after creation.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true)]
        [string]$Filename,

        [ValidateSet('basic', 'full')]
        [string]$Level = 'full',

        [string]$Comment,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Filename, "Create $Level backup")) {
            try {
                $params = @{
                    filename = $Filename
                    level = $Level
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $params.Add('comment', $Comment)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type systembackup -Payload $params -Action create

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    $backup = Get-NSSystemFile -Session $Session -FileLocation '/var/ns_sys_backup' -Filename "$($Filename).tgz"
                    $backup
                }
            } catch {
                throw $_
            }
        }
    }
}

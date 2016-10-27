<#
Copyright 2016 Brandon Olin

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

function Remove-NSBackup {
    <#
    .SYNOPSIS
        Remove a backup file from the NetScaler.

    .DESCRIPTION
        Remove a backup file from the NetScaler.

    .EXAMPLE
        Remove-NSBackup -Name 'test.tgz'

        Remove a backup file called 'test.tgz' from the NetScaler.
    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the backup file to remove.

    .PARAMETER Force
        Suppress confirmation when removing a backup.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Filename')]
        [string[]]$Name,        

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete backup')) {                
                _InvokeNSRestApi -Session $Session -Method DELETE -Type systembackup -Resource $item -Action delete
            }
        }
    }
}

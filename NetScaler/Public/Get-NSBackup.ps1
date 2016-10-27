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

function Get-NSBackup {
    <#
    .SYNOPSIS
        Gets the specified NetScaler backup object.

    .DESCRIPTION
        Gets the specified NetScaler backup object.

    .EXAMPLE
        Get-NSBackup | Format-Table

        Get all backup objects.
    .EXAMPLE
        Get-NSLBServer -Name 'test.tgz'
    
        Get the backup object 'test.tgz'.
    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the backup objects to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('Filename')]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type systembackup -Resource $item -Action Get 
                if ($response.errorcode -ne 0) { throw $response }
                if ($Response.psobject.properties.name -contains 'systembackup') {
                    $response.systembackup
                }
            }
        } else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type systembackup -Action Get
            if ($response.errorcode -ne 0) { throw $response }
            if ($Response.psobject.properties.name -contains 'systembackup') {
                $response.systembackup
            }
        }
    }
}

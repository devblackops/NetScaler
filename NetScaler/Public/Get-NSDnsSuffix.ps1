<#
Copyright 2016 Iain Brighton

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

function Get-NSDnsSuffix {
    <#
    .SYNOPSIS
        Gets the specified DNS suffix object.

    .DESCRIPTION
        Gets the specified DNS suffix object.

    .EXAMPLE
        Get-NSDnsSuffix

        Get all DNS suffix objects.

    .EXAMPLE
        Get-NSDnsSuffix -Suffix 'lab.local'

        Get the DNS suffix object named 'lab.local'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Suffix
        The name or names of the DNS suffixes to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Suffix = @()
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        try {
            if ($Suffix.Count -gt 0) {
                foreach ($item in $Suffix) {
                    $response = _InvokeNSRestApi -Session $Session -Method Get -Type dnssuffix -Resource $item -Action Get
                    if ($response.errorcode -ne 0) { throw $response }
                    if ($Response.psobject.properties.name -contains 'dnssuffix') {
                        $response.dnssuffix
                    }
                }
            } else {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type dnssuffix -Action Get
                if ($response.errorcode -ne 0) { throw $response }
                if ($Response.psobject.properties.name -contains 'dnssuffix') {
                    $response.dnssuffix
                }
            }
        }
        catch {
            throw $_
        }
    }
}

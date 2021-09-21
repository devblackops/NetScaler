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

function Get-NSAAAGroup {
    <#
    .SYNOPSIS
        Gets NetScaler AAA group(s).

    .DESCRIPTION
        Gets NetScaler AAA group(s). If no parameters are provided all AAA
        groups are returned. The 'Groupname' and 'Filter' parameters can be
        used to select a specific group or groups.

    .EXAMPLE
        Get-NSAAAGroup

        Gets all AAA groups.

    .EXAMPLE
        Get-NSAAAGroup -Name Group1,Group2,Group3

        Gets AAA groups Group1,Group2, and Group3.

    .EXAMPLE
        Get-NSAAAGroup -Filter 'ABC'

        Gets all AAA groups with 'ABC' in the username.

    .PARAMETER Name
        Defines the specific AAA group(s) to be returned.

    .PARAMETER Filter
        When specified, only groups that contain the
        provided string are returned.

    .PARAMETER Session
        The NetScaler session object.
    #>
    [cmdletbinding()]
    param(
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [alias('GroupName')]
        [string[]]$Name,

        [string]$Filter,

        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        Try {
            if (-Not([string]::IsNullOrEmpty($Name))) {
                foreach ($Group in $Name) {
                    $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaagroup -Resource $Group -Action Get
                    if ($response.psobject.properties | Where-Object {$_.name -eq 'aaagroup'}) {
                        $response.aaagroup
                    }
                }
            } else {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaagroup -Action Get
                if ($response.psobject.properties | Where-Object {$_.name -eq 'aaagroup'}) {
                    if (-Not([string]::IsNullOrEmpty($Filter))) {
                        foreach ($item in $response.aaagroup) {
                            if ($item.groupname -match "$Filter") {
                                $item
                            }
                        }
                    } else {
                        $response.aaagroup
                    }
                }
            }
        } Catch {
            Throw $_
        }
    }
}

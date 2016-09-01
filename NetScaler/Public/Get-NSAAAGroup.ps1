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
        Get-NSAAAUser

        Gets all AAA users.

    .EXAMPLE
        Get-NSAAAUser -Username User1,User2,User3

        Gets AAA users User1, User2, and User3.

    .EXAMPLE
        Get-NSAAAUser -Filter 'ABC'

        Gets all AAA users with 'ABC' in the username.

    .PARAMETER Username
        Defines the specific AAA user(s) to be returned.

    .PARAMETER Filter
        When specified, only usernames that contain the
        provided string are returned.

    .PARAMETER Session
        The NetScaler session object.
    #>
    [cmdletbinding()]
    param(
        [Parameter(
            ValueFromPipeline=$true,
            Position=0)]
        [string[]]$Groupname,

        [string]$Filter,

        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        Try {
            if (-Not([string]::IsNullOrEmpty($Groupname))) {
                foreach ($Group in $Groupname) {
                    $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaagroup -Resource $Group -Action Get
                    if ($response.psobject.properties | where name -eq aaagroup) {
                        $response.aaauser
                    }
                }
            } else {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaagroup -Action Get
                if ($response.psobject.properties | where name -eq aaagroup) {
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
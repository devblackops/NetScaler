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

function Get-NSAAAUser {
    <#
    .SYNOPSIS
        Gets NetScaler AAA user(s).

    .DESCRIPTION
        Gets NetScaler AAA user(s). If no parameters are provided all AAA
        users are returned. The 'Username' and 'Filter' parameters can be
        used to select a specific user or a subset of users.

    .EXAMPLE
        Get-NSAAAUser

        Gets all AAA users.

    .EXAMPLE
        Get-NSAAAUser -Username User1,User2,User3

        Gets AAA users User1, User2, and User3.

    .EXAMPLE
        Get-NSAAAUser -Filter 'ABC'

        Gets all AAA users with 'ABC' in the username.

    .PARAMETER Name
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
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [alias('UserName')]
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
                foreach ($User in $Name) {
                    $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaauser -Resource $User -Action Get
                    if ($response.psobject.properties | Where-Object {$_.name -eq 'aaauser'}) {
                        $response.aaauser
                    }
                }
            } else {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaauser -Action Get
                if ($response.psobject.properties | Where-Object {$_.name -eq 'aaauser'}) {
                    if (-Not([string]::IsNullOrEmpty($Filter))) {
                        foreach ($item in $response.aaauser) {
                            if ($item.username -match "$Filter") {
                                $item
                            }
                        }
                    } else {
                        $response.aaauser
                    }
                }
            }
        } Catch {
            Throw $_
        }
    }
}

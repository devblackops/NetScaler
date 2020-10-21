<#
Copyright 2020 Nicolas Rogier

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

function Get-NSAAASession {
    <#
    .SYNOPSIS
        Gets NetScaler AAA session(s).

    .DESCRIPTION
        Gets NetScaler AAA session(s). If no parameters are provided all AAA
        sessions are returned. The 'Username' and 'Filter' parameters can be
        used to select a specific session or a subset of sessions.

    .EXAMPLE
        Get-NSAAASession

        Gets all AAA users.

    .EXAMPLE
        Get-NSAAASession -Username 'User1','User2','User3'

        Gets AAA sessions for User1, User2, and User3.

    .EXAMPLE
        Get-NSAAASession -Filter 'ABC'

        Gets all AAA sessions with 'ABC' in the username.

    .PARAMETER Name
        Defines the specific AAA session(s) to be returned.

    .PARAMETER Filter
        When specified, only sessions that username contain the
        provided string are returned.

    .PARAMETER Session
        The NetScaler session object.
    #>

    [cmdletbinding()]
    param(
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0)]
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
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaasession -Action Get
            if ($response.psobject.properties | Where-Object { $_.name -eq 'aaasession' }) {
                if (-Not([string]::IsNullOrEmpty($Name))) {
                    foreach ($User in $Name) {
                        if ($response.aaasession | Where-Object { $_.username -eq $User }) {
                            $response.aaasession | Where-Object { $_.username -eq $User }
                        }
                    }
                } else {
                    if (-Not([string]::IsNullOrEmpty($Filter))) {
                        foreach ($item in $response.aaasession) {
                            if ($item.username -match "$Filter") {
                                $item
                            }
                        }
                    } else {
                        $response.aaasession
                    }
                }
            }
        } Catch {
            Throw $_
        }
    }
}
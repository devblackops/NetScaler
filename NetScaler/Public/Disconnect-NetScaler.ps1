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

function Disconnect-NetScaler {
    <#
    .SYNOPSIS
        Disconnect session with NetScaler.

    .DESCRIPTION
        Disconnect session with NetScaler.

    .EXAMPLE
        Disconnect-NetScaler

        Disconnect from default NetScaler session.

    .EXAMPLE
        Disconnect-NetScaler -Session $session

        Disconnect from specific NetScaler session object $session.

    .PARAMETER Session
        The NetScaler session object
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session
    )

    _AssertSessionActive

    try {
        Write-Verbose -Message 'Logging out of NetScaler'
        $params = @{
            Uri = $Session.CreateUri("config", "logout")
            Body = ConvertTo-Json -InputObject @{logout = @{}}
            Method = 'POST'
            ContentType = 'application/json'
            WebSession = $session.WebSession
        }
        try {
            Invoke-RestMethod @params
        } catch {
            throw $_
        }
    } catch {
        throw $_
    }
}
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

function Get-NSAAAUserBinding {
    <#
    .SYNOPSIS
        Gets NetScaler AAA user(s) session policy bindings.

    .DESCRIPTION
        Gets NetScaler AAA user(s) session policy bindings.

    .EXAMPLE
        Get-NSAAAUserBinding -Username User1

        Gets session policy bindings for the user 'User1'.

    .EXAMPLE
        Get-NSAAAUser | Get-NSAAAUserBinding

        Gets all AAA users then pipes the result into Get-NSAAAUserBinding
        to get session policy bindings for all users.

    .PARAMETER Name
        Defines the user(s) for which session policy bindings are
        to be returned.

    .PARAMETER Session
        The NetScaler session object.
    #>
    [cmdletbinding()]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        [alias('UserName')]
        [string[]]$Name,

        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        Try {
            foreach ($User in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaauser_binding -Resource $User -Action Get
                if ($response.psobject.properties | Where-Object {$_.name -eq 'aaauser_binding'}) {
                    $response.aaauser_binding
                }
            }
        } Catch {
            Throw $_
        }
    }
}

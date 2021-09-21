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

function Get-NSAAAGroupBinding {
    <#
    .SYNOPSIS
        Gets NetScaler AAA group(s) session policy bindings.

    .DESCRIPTION
        Gets NetScaler AAA group(s) session policy bindings.

    .EXAMPLE
        Get-NSAAAGroupBinding -Groupname Group1

        Gets session policy bindings for the group 'Group1'.

    .EXAMPLE
        Get-NSAAAGroup | Get-NSAAAGroupBinding

        Gets all AAA groups then pipes the result to Get-NSAAAGroupBinding
        to get session policy bindings for all groups.

    .PARAMETER Name
        Defines the group(s) for which session policy bindings are
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
        [alias('GroupName')]
        [string[]]$Name,

        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        Try {
            foreach ($Group in $Name) {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type aaagroup_binding -Resource $Group -Action Get
                if ($response.psobject.properties | Where-Object {$_.name -eq 'aaagroup_binding'}) {
                    $response.aaagroup_binding
                }
            }
        } Catch {
            Throw $_
        }
    }
}

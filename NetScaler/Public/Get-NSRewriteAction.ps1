<#
Copyright 2016 Dominique Broeglin

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

function Get-NSRewriteAction {
    <#
    .SYNOPSIS
        Gets the specified rewrite action object.

    .DESCRIPTION
        Gets the specified rewrite action object.

    .EXAMPLE
        Get-NSRewriteAction

        Get all rewrite action objects.

    .EXAMPLE
        Get-NSRewriteAction -Name 'foobar'
    
        Get the rewrite action named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the rewrite actions to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        _InvokeNSRestApiGet -Session $Session -Type rewriteaction -Name $Name
    }
}

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

function Get-NSHostname {
    <#
    .SYNOPSIS
        Get NetScaler hostname

    .DESCRIPTION
        Get NetScaler hostname

    .EXAMPLE
        Get-NSHostname

        Gets the current NetScaler hostname.

    .EXAMPLE
        Get-NSHostname -Session $session

        Gets the current NetScaler hostname using session $session.
        
    .PARAMETER Session
        The NetScaler session object.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        $response = _InvokeNSRestApi -Session $Session -Method Get -Type nshostname -Action Get
        return $response.nshostname
    }
}
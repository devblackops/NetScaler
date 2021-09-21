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

function Get-NSTimeZone {
    <#
    .SYNOPSIS
        Gets the NetScaler's timezone.

    .DESCRIPTION
        Gets the NetScaler's timezone.

    .EXAMPLE
        Get-NSTimeZone -Session $session

        Returns the configured timezone.

    .PARAMETER Session
        The NetScaler session object.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            $config = _InvokeNSRestApi -Session $Session -Method GET -Type nsconfig -Action get
            return $config.nsconfig.timezone
        }
        catch {
            throw $_
        }
    }
}

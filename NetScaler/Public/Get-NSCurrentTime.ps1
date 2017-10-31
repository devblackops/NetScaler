<#
Copyright 2017 Ryan Butler

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
function Get-NSCurrentTime {
    <#
    .SYNOPSIS
        Retrieve the current NetScaler Time and returns as date object
    .DESCRIPTION
        Retrieve the current NetScaler Time and returns as date object
    .PARAMETER Session
        An existing custom NetScaler Web Request Session object returned by Connect-NSAppliance
    .EXAMPLE
        Get-NSCurrentTime -Session $Session
    .NOTES
        Author: Ryan Butler - @ryan_c_butler
        Date Created: 09-07-2017
    #>
    [CmdletBinding()]
    param (
        $Session = $Script:Session
    )

    begin {
        _AssertSessionActive
    }

    process {
        $response = _InvokeNSRestApi -Session $Session -Method GET -Type nsconfig
        $currentdatestr = $response.nsconfig.systemtime
        Write-Verbose "systemtime: $currentdatestr"
        $date = Get-Date -Date '1/1/1970'
        $nsdate = $date.AddSeconds($currentdatestr)
        $nsdate
    }
}

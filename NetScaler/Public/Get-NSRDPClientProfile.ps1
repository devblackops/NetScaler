<#
Copyright 2018 Iain Brighton

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

function Get-NSRDPClientProfile {
    <#
    .SYNOPSIS
        Gets the specified RDP client profile object(s).

    .DESCRIPTION
        Gets the specified VPN session profile object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSRDPClientProfile

        Get all RDP client profile objects.

    .EXAMPLE
        Get-NSRDPClientProfile -Name 'foobar'
    
        Get the RDP client profile named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the RDP client profiles to get.
    #>
    [CmdletBinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]] $Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        _InvokeNSRestApiGet -Session $Session -Type rdpclientprofile -Name $Name
    }
}

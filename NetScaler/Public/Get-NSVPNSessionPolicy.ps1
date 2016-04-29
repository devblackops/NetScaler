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

function Get-NSVPNSessionPolicy {
    <#
    .SYNOPSIS
        Gets the specified VPN session policy object(s).

    .DESCRIPTION
        Gets the specified VPN session policy object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSVPNSessionPolicy

        Get all VPN session policy objects.

    .EXAMPLE
        Get-NSVPNSessionPolicy -Name 'foobar'
    
        Get the VPN session policy named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the VPN session policys to get.

    .PARAMETER PolicyName
        A filter to apply to the policy name value.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @(),

        [string]$PolicyName
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('PolicyName')) {
            $Filters['name'] = $PolicyName
        }
        _InvokeNSRestApiGet -Session $Session -Type vpnsessionpolicy -Name $Name -Filters $Filters
    }
}

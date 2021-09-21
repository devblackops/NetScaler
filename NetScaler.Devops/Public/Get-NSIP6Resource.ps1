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

function Get-NSIP6Resource {
    <#
    .SYNOPSIS
        Gets the specified IPv6 resource object(s).

    .DESCRIPTION
        Gets the specified IPv6 resource object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSIP6Resource

        Get all IPv6 resource objects.

    .EXAMPLE
        Get-NSIP6Resource -Name 'foobar'
    
        Get the IPv6 resource named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the IPv6 resources to get.

    .PARAMETER MappedIP
        A filter to apply to the mapped IP value.

    .PARAMETER State
        A filter to apply to the state value.

    .PARAMETER IPAddress
        A filter to apply to the IPv6 address value.

    .PARAMETER Scope
        A filter to apply to the scope value.

    .PARAMETER TrafficDomain
        A filter to apply to the traffic domain value.

    .PARAMETER Type
        A filter to apply to the IP type value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$MappedIP,

        [Parameter(ParameterSetName='search')]

        [string]$State,

        [Parameter(ParameterSetName='search')]

        [string]$IPAddress,

        [Parameter(ParameterSetName='search')]

        [string]$Scope,

        [Parameter(ParameterSetName='search')]

        [string]$TrafficDomain,

        [Parameter(ParameterSetName='search')]

        [string]$Type
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('MappedIP')) {
            $Filters['map'] = $MappedIP
        }
        if ($PSBoundParameters.ContainsKey('State')) {
            $Filters['curstate'] = $State
        }
        if ($PSBoundParameters.ContainsKey('IPAddress')) {
            $Filters['ipv6address'] = $IPAddress
        }
        if ($PSBoundParameters.ContainsKey('Scope')) {
            $Filters['scope'] = $Scope
        }
        if ($PSBoundParameters.ContainsKey('TrafficDomain')) {
            $Filters['td'] = $TrafficDomain
        }
        if ($PSBoundParameters.ContainsKey('Type')) {
            $Filters['iptype'] = $Type
        }
        _InvokeNSRestApiGet -Session $Session -Type nsip6 -Name $Name -Filters $Filters
    }
}

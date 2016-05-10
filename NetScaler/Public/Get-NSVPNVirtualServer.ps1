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

function Get-NSVPNVirtualServer {
    <#
    .SYNOPSIS
        Gets the specified VPN virtual server object(s).

    .DESCRIPTION
        Gets the specified VPN virtual server object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSVPNVirtualServer

        Get all VPN virtual server objects.

    .EXAMPLE
        Get-NSVPNVirtualServer -Name 'foobar'
    
        Get the VPN virtual server named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the VPN virtual servers to get.

    .PARAMETER ServerName
        A filter to apply to the virtual server name value.

    .PARAMETER MaxAAAUsers
        A filter to apply to the max AAA users value.

    .PARAMETER CurrentState
        A filter to apply to the virtual server current state value.

    .PARAMETER Port
        A filter to apply to the port value.

    .PARAMETER CurrentTotalUsers
        A filter to apply to the current total users value.

    .PARAMETER IPv46
        A filter to apply to the IPv4 or IPv6 address value.

    .PARAMETER CurrentAAAUsers
        A filter to apply to the current AAA users value.

    .PARAMETER ServiceType
        A filter to apply to the service type value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$ServerName,

        [Parameter(ParameterSetName='search')]

        [string]$MaxAAAUsers,

        [Parameter(ParameterSetName='search')]

        [string]$CurrentState,

        [Parameter(ParameterSetName='search')]

        [string]$Port,

        [Parameter(ParameterSetName='search')]

        [string]$CurrentTotalUsers,

        [Parameter(ParameterSetName='search')]

        [string]$IPv46,

        [Parameter(ParameterSetName='search')]

        [string]$CurrentAAAUsers,

        [Parameter(ParameterSetName='search')]

        [string]$ServiceType
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('ServerName')) {
            $Filters['name'] = $ServerName
        }
        if ($PSBoundParameters.ContainsKey('MaxAAAUsers')) {
            $Filters['maxaaausers'] = $MaxAAAUsers
        }
        if ($PSBoundParameters.ContainsKey('CurrentState')) {
            $Filters['curstate'] = $CurrentState
        }
        if ($PSBoundParameters.ContainsKey('Port')) {
            $Filters['port'] = $Port
        }
        if ($PSBoundParameters.ContainsKey('CurrentTotalUsers')) {
            $Filters['curtotalusers'] = $CurrentTotalUsers
        }
        if ($PSBoundParameters.ContainsKey('IPv46')) {
            $Filters['ipv46'] = $IPv46
        }
        if ($PSBoundParameters.ContainsKey('CurrentAAAUsers')) {
            $Filters['curaaausers'] = $CurrentAAAUsers
        }
        if ($PSBoundParameters.ContainsKey('ServiceType')) {
            $Filters['servicetype'] = $ServiceType
        }
        _InvokeNSRestApiGet -Session $Session -Type vpnvserver -Name $Name -Filters $Filters
    }
}

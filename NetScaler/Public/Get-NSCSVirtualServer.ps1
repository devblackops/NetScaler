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

function Get-NSCSVirtualServer {
    <#
    .SYNOPSIS
        Gets the specified content switching virtual server object(s).

    .DESCRIPTION
        Gets the specified content switching virtual server object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSCSVirtualServer

        Get all content switching virtual server objects.

    .EXAMPLE
        Get-NSCSVirtualServer -Name 'foobar'
    
        Get the content switching virtual server named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the content switching virtual servers to get.

    .PARAMETER CurrentState
        A filter to apply to the current state value.

    .PARAMETER Port
        A filter to apply to the port value.

    .PARAMETER TrafficDomain
        A filter to apply to the traffic domain value.

    .PARAMETER ServerName
        A filter to apply to the virtual server name value.

    .PARAMETER TargetType
        A filter to apply to the target type value.

    .PARAMETER IPv46
        A filter to apply to the IPv4 or IPv6 address value.

    .PARAMETER ServiceType
        A filter to apply to the service type value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$CurrentState,

        [Parameter(ParameterSetName='search')]

        [string]$Port,

        [Parameter(ParameterSetName='search')]

        [string]$TrafficDomain,

        [Parameter(ParameterSetName='search')]

        [string]$ServerName,

        [Parameter(ParameterSetName='search')]

        [string]$TargetType,

        [Parameter(ParameterSetName='search')]

        [string]$IPv46,

        [Parameter(ParameterSetName='search')]

        [string]$ServiceType
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('CurrentState')) {
            $Filters['curstate'] = $CurrentState
        }
        if ($PSBoundParameters.ContainsKey('Port')) {
            $Filters['port'] = $Port
        }
        if ($PSBoundParameters.ContainsKey('TrafficDomain')) {
            $Filters['td'] = $TrafficDomain
        }
        if ($PSBoundParameters.ContainsKey('ServerName')) {
            $Filters['name'] = $ServerName
        }
        if ($PSBoundParameters.ContainsKey('TargetType')) {
            $Filters['targettype'] = $TargetType
        }
        if ($PSBoundParameters.ContainsKey('IPv46')) {
            $Filters['ipv46'] = $IPv46
        }
        if ($PSBoundParameters.ContainsKey('ServiceType')) {
            $Filters['servicetype'] = $ServiceType
        }
        _InvokeNSRestApiGet -Session $Session -Type csvserver -Name $Name -Filters $Filters
    }
}

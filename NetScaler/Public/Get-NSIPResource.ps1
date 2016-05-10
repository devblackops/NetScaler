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

function Get-NSIPResource {
    <#
    .SYNOPSIS
        Gets the specified IPv46 resource object(s).

    .DESCRIPTION
        Gets the specified IPv46 resource object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSIPResource

        Get all IPv46 resource objects.

    .EXAMPLE
        Get-NSIPResource -Name 'foobar'
    
        Get the IPv46 resource named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the IPv46 resources to get.

    .PARAMETER State
        A filter to apply to the state value.

    .PARAMETER IPAddress
        A filter to apply to the IPv4 address value.

    .PARAMETER Icmp
        A filter to apply to the ICMP value.

    .PARAMETER TrafficDomain
        A filter to apply to the traffic domain value.

    .PARAMETER VirtualServer
        A filter to apply to the virtual server value.

    .PARAMETER Arp
        A filter to apply to the ARP value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$State,

        [Parameter(ParameterSetName='search')]

        [string]$IPAddress,

        [Parameter(ParameterSetName='search')]

        [string]$Icmp,

        [Parameter(ParameterSetName='search')]

        [string]$TrafficDomain,

        [Parameter(ParameterSetName='search')]

        [string]$VirtualServer,

        [Parameter(ParameterSetName='search')]

        [string]$Arp
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('State')) {
            $Filters['state'] = $State
        }
        if ($PSBoundParameters.ContainsKey('IPAddress')) {
            $Filters['ipaddress'] = $IPAddress
        }
        if ($PSBoundParameters.ContainsKey('Icmp')) {
            $Filters['icmp'] = $Icmp
        }
        if ($PSBoundParameters.ContainsKey('TrafficDomain')) {
            $Filters['td'] = $TrafficDomain
        }
        if ($PSBoundParameters.ContainsKey('VirtualServer')) {
            $Filters['vserver'] = $VirtualServer
        }
        if ($PSBoundParameters.ContainsKey('Arp')) {
            $Filters['arp'] = $Arp
        }
        _InvokeNSRestApiGet -Session $Session -Type nsip -Name $Name -Filters $Filters
    }
}

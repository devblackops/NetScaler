
<#
Copyright $CopyrightYear $Author

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

function Get-NSHANode {
    <#
    .SYNOPSIS
        Gets the specified HA Node object(s).

    .DESCRIPTION
        Gets the specified HA Node object(s).
        Either returns a single object identified by its identifier (-ID parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSHANode

        Get all HA Node objects.

    .EXAMPLE
        Get-NSHANode -ID 'foobar'
    
        Get the HA Node named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER ID
        The identifier/name or identifiers/names of the HA Nodes to get.

    .PARAMETER IPAddress
        A filter to apply to the ipaddress property.

    .PARAMETER HASync
        A filter to apply to the hasync property.

    .PARAMETER Name
        A filter to apply to the name property.

    .PARAMETER HAStatus
        A filter to apply to the hastatus property.

    .PARAMETER State
        A filter to apply to the state property.

    .NOTES
        Nitro implementation status: partial        

    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    Param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$ID = @(),

        [Parameter(ParameterSetName='search')]
        [string]$IPAddress,

        [Parameter(ParameterSetName='search')]
        [string]$HASync,

        [Parameter(ParameterSetName='search')]
        [string]$Name,

        [Parameter(ParameterSetName='search')]
        [string]$HAStatus,

        [Parameter(ParameterSetName='search')]
        [string]$State

    )
    Begin {
        _AssertSessionActive
    }

    Process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('IPAddress')) {
            $Filters['ipaddress'] = $IPAddress
        }
        if ($PSBoundParameters.ContainsKey('HASync')) {
            $Filters['hasync'] = $HASync
        }
        if ($PSBoundParameters.ContainsKey('Name')) {
            $Filters['name'] = $Name
        }
        if ($PSBoundParameters.ContainsKey('HAStatus')) {
            $Filters['hastatus'] = $HAStatus
        }
        if ($PSBoundParameters.ContainsKey('State')) {
            $Filters['state'] = $State
        }
        _InvokeNSRestApiGet -Session $Session -Type hanode -Name $ID -Filters $Filters

    }
}
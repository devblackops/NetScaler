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

function Get-NSNTPServer {
    <#
    .SYNOPSIS
        Gets the specified NTP server object(s).

    .DESCRIPTION
        Gets the specified NTP server object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSNTPServer

        Get all NTP server objects.

    .EXAMPLE
        Get-NSNTPServer -Name 'foobar'
    
        Get the NTP server named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the NTP servers to get.

    .PARAMETER ServerName
        A filter to apply to the NTP server name value.

    .PARAMETER PreferredNTPServer
        A filter to apply to the preferred NTP server value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$ServerName,

        [Parameter(ParameterSetName='search')]

        [string]$PreferredNTPServer
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('ServerName')) {
            $Filters['servername'] = $ServerName
        }
        if ($PSBoundParameters.ContainsKey('PreferredNTPServer')) {
            $Filters['preferredntpserver'] = $PreferredNTPServer
        }
        _InvokeNSRestApiGet -Session $Session -Type ntpserver -Name $Name -Filters $Filters
    }
}

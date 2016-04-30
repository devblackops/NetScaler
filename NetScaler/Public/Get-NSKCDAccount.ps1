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

function Get-NSKCDAccount {
    <#
    .SYNOPSIS
        Gets the specified KCD account object(s).

    .DESCRIPTION
        Gets the specified KCD account object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSKCDAccount

        Get all KCD account objects.

    .EXAMPLE
        Get-NSKCDAccount -Name 'foobar'
    
        Get the KCD account named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the KCD accounts to get.

    .PARAMETER KCDSPN
        A filter to apply to the KCD service principal name value.

    .PARAMETER Realm
        A filter to apply to the Realm value.

    .PARAMETER AccountName
        A filter to apply to the KCD account name value.

    .PARAMETER Keytab
        A filter to apply to the keytab value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$KCDSPN,

        [Parameter(ParameterSetName='search')]

        [string]$Realm,

        [Parameter(ParameterSetName='search')]

        [string]$AccountName,

        [Parameter(ParameterSetName='search')]

        [string]$Keytab
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('KCDSPN')) {
            $Filters['kcdspn'] = $KCDSPN
        }
        if ($PSBoundParameters.ContainsKey('Realm')) {
            $Filters['realmstr'] = $Realm
        }
        if ($PSBoundParameters.ContainsKey('AccountName')) {
            $Filters['kcdaccount'] = $AccountName
        }
        if ($PSBoundParameters.ContainsKey('Keytab')) {
            $Filters['keytab'] = $Keytab
        }
        _InvokeNSRestApiGet -Session $Session -Type aaakcdaccount -Name $Name -Filters $Filters
    }
}

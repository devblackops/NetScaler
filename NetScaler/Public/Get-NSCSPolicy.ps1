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

function Get-NSCSPolicy {
    <#
    .SYNOPSIS
        Gets the specified content switching policy object(s).

    .DESCRIPTION
        Gets the specified content switching policy object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSCSPolicy

        Get all content switching policy objects.

    .EXAMPLE
        Get-NSCSPolicy -Name 'foobar'
    
        Get the content switching policy named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the content switching policys to get.

    .PARAMETER Url
        A filter to apply to the URL value.

    .PARAMETER Domain
        A filter to apply to the domain value.

    .PARAMETER Action
        A filter to apply to the action name value.

    .PARAMETER PolicyName
        A filter to apply to the policy name value.

    .PARAMETER Rule
        A filter to apply to the rule value.

    .PARAMETER LogAction
        A filter to apply to the log action name value.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @(),

        [string]$Url,

        [string]$Domain,

        [string]$Action,

        [string]$PolicyName,

        [string]$Rule,

        [string]$LogAction
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('Url')) {
            $Filters['url'] = $Url
        }
        if ($PSBoundParameters.ContainsKey('Domain')) {
            $Filters['domain'] = $Domain
        }
        if ($PSBoundParameters.ContainsKey('Action')) {
            $Filters['action'] = $Action
        }
        if ($PSBoundParameters.ContainsKey('PolicyName')) {
            $Filters['policyname'] = $PolicyName
        }
        if ($PSBoundParameters.ContainsKey('Rule')) {
            $Filters['rule'] = $Rule
        }
        if ($PSBoundParameters.ContainsKey('LogAction')) {
            $Filters['logaction'] = $LogAction
        }
        _InvokeNSRestApiGet -Session $Session -Type cspolicy -Name $Name -Filters $Filters
    }
}

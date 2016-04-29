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

function Get-NSRewritePolicy {
    <#
    .SYNOPSIS
        Gets the specified rewrite policy object(s).

    .DESCRIPTION
        Gets the specified rewrite policy object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSRewritePolicy

        Get all rewrite policy objects.

    .EXAMPLE
        Get-NSRewritePolicy -Name 'foobar'
    
        Get the rewrite policy named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the rewrite policys to get.

    .PARAMETER Rule
        A filter to apply to the rule value.

    .PARAMETER UndefinedHits
        A filter to apply to the undefined hits value.

    .PARAMETER Action
        A filter to apply to the action value.

    .PARAMETER PolicyName
        A filter to apply to the rewrite policy name value.

    .PARAMETER ShowBuiltin
        If true, show builtins. Default value: False

    .PARAMETER UndefinedAction
        A filter to apply to the undefined action value.

    .PARAMETER Hits
        A filter to apply to the hits value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$Rule,

        [Parameter(ParameterSetName='search')]

        [string]$UndefinedHits,

        [Parameter(ParameterSetName='search')]

        [string]$Action,

        [Parameter(ParameterSetName='search')]

        [string]$PolicyName,

        [Parameter(ParameterSetName='search')]

        [switch]$ShowBuiltin,

        [Parameter(ParameterSetName='search')]

        [string]$UndefinedAction,

        [Parameter(ParameterSetName='search')]

        [string]$Hits
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('Rule')) {
            $Filters['rule'] = $Rule
        }
        if ($PSBoundParameters.ContainsKey('UndefinedHits')) {
            $Filters['undefhits'] = $UndefinedHits
        }
        if ($PSBoundParameters.ContainsKey('Action')) {
            $Filters['action'] = $Action
        }
        if ($PSBoundParameters.ContainsKey('PolicyName')) {
            $Filters['name'] = $PolicyName
        }
        if (!$ShowBuiltin) {
            $Filters['isdefault'] = 'false'
        }
        if ($PSBoundParameters.ContainsKey('UndefinedAction')) {
            $Filters['undefaction'] = $UndefinedAction
        }
        if ($PSBoundParameters.ContainsKey('Hits')) {
            $Filters['hits'] = $Hits
        }
        _InvokeNSRestApiGet -Session $Session -Type rewritepolicy -Name $Name -Filters $Filters
    }
}

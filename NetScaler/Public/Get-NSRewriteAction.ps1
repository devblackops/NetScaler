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

function Get-NSRewriteAction {
    <#
    .SYNOPSIS
        Gets the specified rewrite action object(s).

    .DESCRIPTION
        Gets the specified rewrite action object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSRewriteAction

        Get all rewrite action objects.

    .EXAMPLE
        Get-NSRewriteAction -Name 'foobar'
    
        Get the rewrite action named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the rewrite actions to get.

    .PARAMETER Pattern
        A filter to apply to the pattern value.

    .PARAMETER Expression
        A filter to apply to the  value.

    .PARAMETER Target
        A filter to apply to the target value.

    .PARAMETER Type
        A filter to apply to the type value.

    .PARAMETER Hits
        A filter to apply to the hits value.

    .PARAMETER ActionName
        A filter to apply to the action name value.

    .PARAMETER UndefinedHits
        A filter to apply to the undefined hits value.

    .PARAMETER ShowBuiltin
        If true, show builtins. Default value: False
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @(),

        [string]$Pattern,

        [string]$Expression,

        [string]$Target,

        [string]$Type,

        [string]$Hits,

        [string]$ActionName,

        [string]$UndefinedHits,

        [switch]$ShowBuiltin
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('Pattern')) {
            $Filters['pattern'] = $Pattern
        }
        if ($PSBoundParameters.ContainsKey('Expression')) {
            $Filters['stringbuilderexpr'] = $Expression
        }
        if ($PSBoundParameters.ContainsKey('Target')) {
            $Filters['target'] = $Target
        }
        if ($PSBoundParameters.ContainsKey('Type')) {
            $Filters['type'] = $Type
        }
        if ($PSBoundParameters.ContainsKey('Hits')) {
            $Filters['hits'] = $Hits
        }
        if ($PSBoundParameters.ContainsKey('ActionName')) {
            $Filters['name'] = $ActionName
        }
        if ($PSBoundParameters.ContainsKey('UndefinedHits')) {
            $Filters['undefhits'] = $UndefinedHits
        }
        if (!$ShowBuiltin) {
            $Filters['isdefault'] = 'false'
        }
        _InvokeNSRestApiGet -Session $Session -Type rewriteaction -Name $Name -Filters $Filters
    }
}

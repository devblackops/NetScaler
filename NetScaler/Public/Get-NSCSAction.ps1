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

function Get-NSCSAction {
    <#
    .SYNOPSIS
        Gets the specified content switching action object(s).

    .DESCRIPTION
        Gets the specified content switching action object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSCSAction

        Get all content switching action objects.

    .EXAMPLE
        Get-NSCSAction -Name 'foobar'
    
        Get the content switching action named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the content switching actions to get.

    .PARAMETER UndefinedHits
        A filter to apply to the undefined hits value.

    .PARAMETER Comment
        A filter to apply to the comment value.

    .PARAMETER ReferenceCount
        A filter to apply to the reference count value.

    .PARAMETER TargetLBVserver
        A filter to apply to the target load balancer virtual server value.

    .PARAMETER ActionName
        A filter to apply to the action name value.

    .PARAMETER Hits
        A filter to apply to the hits value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$UndefinedHits,

        [Parameter(ParameterSetName='search')]

        [string]$Comment,

        [Parameter(ParameterSetName='search')]

        [string]$ReferenceCount,

        [Parameter(ParameterSetName='search')]

        [string]$TargetLBVserver,

        [Parameter(ParameterSetName='search')]

        [string]$ActionName,

        [Parameter(ParameterSetName='search')]

        [string]$Hits
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('UndefinedHits')) {
            $Filters['undefhits'] = $UndefinedHits
        }
        if ($PSBoundParameters.ContainsKey('Comment')) {
            $Filters['comment'] = $Comment
        }
        if ($PSBoundParameters.ContainsKey('ReferenceCount')) {
            $Filters['referencecount'] = $ReferenceCount
        }
        if ($PSBoundParameters.ContainsKey('TargetLBVserver')) {
            $Filters['targetlbvserver'] = $TargetLBVserver
        }
        if ($PSBoundParameters.ContainsKey('ActionName')) {
            $Filters['name'] = $ActionName
        }
        if ($PSBoundParameters.ContainsKey('Hits')) {
            $Filters['hits'] = $Hits
        }
        _InvokeNSRestApiGet -Session $Session -Type csaction -Name $Name -Filters $Filters
    }
}

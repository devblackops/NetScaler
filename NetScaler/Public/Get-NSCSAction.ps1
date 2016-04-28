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
        Gets the specified content switching action object.

    .DESCRIPTION
        Gets the specified content switching action object.

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

    .PARAMETER Comment
        A filter to apply to the comment value.

    .PARAMETER UndefinedHits
        A filter to apply to the undefined hits value.

    .PARAMETER Hits
        A filter to apply to the hits value.

    .PARAMETER TargetLBVserver
        A filter to apply to the target load balancer virtual server value.

    .PARAMETER ReferenceCount
        A filter to apply to the reference count value.

    .PARAMETER ActionName
        A filter to apply to the action name value.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @(),

        [string]$Comment,

        [string]$UndefinedHits,

        [string]$Hits,

        [string]$TargetLBVserver,

        [string]$ReferenceCount,

        [string]$ActionName
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('Comment')) {
            $Filters['comment'] = (Get-Variable -Name 'Comment').Value
        }
        if ($PSBoundParameters.ContainsKey('UndefinedHits')) {
            $Filters['undefhits'] = (Get-Variable -Name 'UndefinedHits').Value
        }
        if ($PSBoundParameters.ContainsKey('Hits')) {
            $Filters['hits'] = (Get-Variable -Name 'Hits').Value
        }
        if ($PSBoundParameters.ContainsKey('TargetLBVserver')) {
            $Filters['targetlbvserver'] = (Get-Variable -Name 'TargetLBVserver').Value
        }
        if ($PSBoundParameters.ContainsKey('ReferenceCount')) {
            $Filters['referencecount'] = (Get-Variable -Name 'ReferenceCount').Value
        }
        if ($PSBoundParameters.ContainsKey('ActionName')) {
            $Filters['name'] = (Get-Variable -Name 'ActionName').Value
        }
        _InvokeNSRestApiGet -Session $Session -Type csaction -Name $Name -Filters $Filters
    }
}

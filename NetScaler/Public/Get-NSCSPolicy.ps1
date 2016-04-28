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
        Gets the specified content switching policy object.

    .DESCRIPTION
        Gets the specified content switching policy object.

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

    .PARAMETER Action
        A filter to apply to the action name value.

    .PARAMETER Rule
        A filter to apply to the rule value.

    .PARAMETER PolicyName
        A filter to apply to the policy name value.

    .PARAMETER Domain
        A filter to apply to the domain value.

    .PARAMETER Url
        A filter to apply to the URL value.

    .PARAMETER LogAction
        A filter to apply to the log action name value.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @(),

        [string]$Action,

        [string]$Rule,

        [string]$PolicyName,

        [string]$Domain,

        [string]$Url,

        [string]$LogAction
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('Action')) {
            $Filters['action'] = (Get-Variable -Name 'Action').Value
        }
        if ($PSBoundParameters.ContainsKey('Rule')) {
            $Filters['rule'] = (Get-Variable -Name 'Rule').Value
        }
        if ($PSBoundParameters.ContainsKey('PolicyName')) {
            $Filters['policyname'] = (Get-Variable -Name 'PolicyName').Value
        }
        if ($PSBoundParameters.ContainsKey('Domain')) {
            $Filters['domain'] = (Get-Variable -Name 'Domain').Value
        }
        if ($PSBoundParameters.ContainsKey('Url')) {
            $Filters['url'] = (Get-Variable -Name 'Url').Value
        }
        if ($PSBoundParameters.ContainsKey('LogAction')) {
            $Filters['logaction'] = (Get-Variable -Name 'LogAction').Value
        }
        _InvokeNSRestApiGet -Session $Session -Type cspolicy -Name $Name -Filters $Filters
    }
}

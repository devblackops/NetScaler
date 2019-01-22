<#
Copyright 2019 Iain Brighton

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

function Get-NSSystemGroupCommandPolicyBinding {
    <#
    .SYNOPSIS
        Gets the specified system group command policy binding object.

    .DESCRIPTION
        Gets the specified system group command policy binding object.

    .EXAMPLE
        Get-NSSystemGroupCommandPolicyBinding -Name 'G-NetScaler-Admins'

        Get all bound command policies on the 'G-NetScaler-Admins' system group object.

    .EXAMPLE
        Get-NSSystemGroupCommandPolicyBinding -Name 'G-NetScaler-Admins' -PolicyName 'superuser'

        Get the 'superuser' command policy binding object defined on the 'G-NetScaler-Admins' system group.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the system groups.

    .PARAMETER PolicyName
        The name of the command policy to return.

        Typical values: operator, read-only, network, superuser, sysadmin, partition-operator, partition-read-only, partition-network, partition-admin

    .PARAMETER Priority
        The priority of the command policy binding to return.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [alias('GroupName')]
        [string[]] $Name,

        [string] $PolicyName,

        [int] $Priority
    )

    process {
        try {
            $filters = @{ }

            if ($PSBoundParameters.ContainsKey('PolicyName')) {
                $filters.Add('policyname', $PolicyName)
            }
            if ($PSBoundParameters.ContainsKey('Priority')) {
                $filters.Add('priority', $Priority)
            }

            _InvokeNSRestApiGet -Session $Session -Type systemgroup_systemcmdpolicy_binding -Name $Name -Filters $filters
        }
        catch {
            throw $_
        }
    }
}

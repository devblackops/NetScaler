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

function Add-NSSystemGroupCommandPolicyBinding {
    <#
    .SYNOPSIS
        Adds a system command binding to an existing system group.

    .DESCRIPTION
        Adds a system command binding to an existing system group.

    .EXAMPLE
        Add-NSSystemGroupCommandPolicyBinding -GroupName 'G-NetScalerAdmins' -PolicyName 'superuser'

        Binds the 'superuser' command policy to the 'G-NetScalerAdmins' system group.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER GroupName
        Name of the group to bind the command policy.

    .PARAMETER PolicyName
        Name of the command policy to bind to the system group.

    .PARAMETER Priority
        The priority of the command policy.

    .PARAMETER Force
        Suppress confirmation when creating the system group.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:Session,

        [parameter(Mandatory)]
        [alias('Name')]
        [string] $GroupName,

        [parameter(Mandatory)]
        [string] $PolicyName,

        [int] $Priority = 100,

        [switch] $Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($GroupName, 'Add system group command policy binding')) {
            try {
                $params = @{
                    groupname = $GroupName
                    policyname = $PolicyName
                    priority = $Priority
                }
                _InvokeNSRestApi -Session $Session -Method PUT -Type systemgroup_systemcmdpolicy_binding -Payload $params
            }
            catch {
                throw $_
            }
        }
    }
}

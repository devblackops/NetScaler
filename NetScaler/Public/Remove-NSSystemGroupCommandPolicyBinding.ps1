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

function Remove-NSSystemGroupCommandPolicyBinding {
    <#
    .SYNOPSIS
        Removes a command policy binding from an existing system group.

    .DESCRIPTION
        Removes a command policy binding from an existing system group.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name(s) of the system group to unbind from the policy.

    .PARAMETER PolicyName
        The name of the command policy to unbind from the system group.

        Typical values: operator, read-only, network, superuser, sysadmin, partition-operator, partition-read-only, partition-network, partition-admin

    .EXAMPLE
        Remove-NSSystemGroupCommandPolicyBinding -Name 'G-NetScaler-Admins' -PolicyName 'superuser'

        Unbinds the command policy named 'superuser' from the system group 'G-NetScaler-Admins'.

    .PARAMETER Force
        Suppress confirmation when removing system group command policy binding.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [alias('GroupName')]
        [string[]] $Name,

        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $PolicyName,

        [switch] $Force
    )

    begin {
        _AssertSessionActive
    }

    process {

        $params =@{
            policyname = $PolicyName
        }
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete system group command policy binding')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type systemgroup_systemcmdpolicy_binding -Resource $item -Arguments $params -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}

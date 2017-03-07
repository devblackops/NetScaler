<#
Copyright 2017 Eric Carr

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

function Add-NSCSVirtualServerPolicyBinding {
     <#
    .SYNOPSIS
        Adds a new content switching virtual server policy binding.

    .DESCRIPTION
        Adds a new content switching virtual server policy binding.

    .EXAMPLE
        Add-NSCSVirtualServerPolicyBinding -Name 'cs01' -PolicyName 'pol01' -TargetLBVServer 'vserver01' -Priority '100'

        Bind the policy 'pol01' as a policy with a priority of 100 to virtual server 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the content switching virtual server.

    .PARAMETER PolicyName
        Name for the content switching policy to bind.

    .PARAMETER TargetLBVServer
        Name for the load balance virtual server.

        Minimum length = 1

    .PARAMETER Priority
        Policy priority.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory=$True)]
        [string]
        $Name,

        [parameter(Mandatory=$True)]
        [string]
        $PolicyName,

        [parameter(Mandatory=$True)]
        [string]
        $TargetLBVServer,

        [ValidateRange(1, 2147483647)]
        [int]
        $Priority,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, 'Add Content Switching Virtual Server Binding')) {
            try {
                if (-not $Priority) {
                    # No priority was passed so find the highest currently used and add 10 to it
                    $CSP = Get-NSCSVirtualServerPolicyBinding $Name | Sort-Object Priority -Descending | Select-Object -First 1
                    $Priority = [double]$CSP.Priority + 10
                }
                
                $params = @{
                    name = $Name
                    policyname = $PolicyName
                    targetlbvserver = $TargetLBVServer
                    priority = $Priority
                }
                
                _InvokeNSRestApi -Session $Session -Method PUT -Type csvserver_cspolicy_binding -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSCSVirtualServerPolicyBinding -Session $Session -Name $Name
                }
            } catch {
                throw $_
            }
        }
    }
}
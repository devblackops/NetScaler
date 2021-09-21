<#
Copyright 2017 Dominique Broeglin

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

function Add-NSLBVirtualServerTrafficPolicyBinding {
     <#
    .SYNOPSIS
        Adds a new load balancer traffic policy binding.

    .DESCRIPTION
        Adds a new load balancer traffic policy binding.

    .EXAMPLE
        Add-NSLBVirtualServerTrafficPolicyBinding -VirtualServerName 'vserver01' -PolicyName 'pol01' -Priority '100'

        Bind the policy 'pol01' as a traffic policy with a priority of 100 to virtual server 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name for the virtual server. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain
        only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@), equal sign (=),
        and hyphen (-) characters. Can be changed after the virtual server is created.

        Minimum length = 1

    .PARAMETER PolicyName
        Name of the policy bound to the LB virtual server.

    .PARAMETER Priority
        Policy priority.

    .PARAMETER Passthru
        Return the policy binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory=$True)]
        [string]
        $VirtualServerName,

        [parameter(Mandatory=$True)]
        [string]
        $PolicyName,

        [parameter(Mandatory=$True)]
        [ValidateRange(1, 2147483647)]
        [int]
        $Priority,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($VirtualServerName, 'Add Virtual Server Binding')) {
            try {

                $params = @{
                    name = $VirtualServerName
                    policyname = $PolicyName
                    bindpoint = 'REQUEST'
                    priority = $Priority
                }

                _InvokeNSRestApi -Session $Session -Method PUT -Type lbvserver_tmtrafficpolicy_binding -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServerTrafficPolicyBinding -Session $Session -Name $VirtualServerName
                }
            } catch {
                throw $_
            }
        }
    }
}
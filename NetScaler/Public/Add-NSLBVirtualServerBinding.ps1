<#
Copyright 2015 Brandon Olin

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

function Add-NSLBVirtualServerBinding {
     <#
    .SYNOPSIS
        Adds a new load balancer server binding.

    .DESCRIPTION
        Adds a new load balancer server binding.

    .EXAMPLE
        Add-NSLBVirtualServerBinding -VirtualServerName 'vserver01' -ServiceGroupName 'sg01'

        Bind the service group 'sg01' to virtual server 'vserver01'.

    .EXAMPLE
        $x = Add-NSLBVirtualServerBinding -VirtualServerName 'vserver01' -ServiceGroupName 'sg01' -Force -PassThru
    
        Bind the service group 'sg01' to virtual server 'vserver01', suppress the confirmation and returl the result.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name for the virtual server. Must begin with an ASCII alphanumeric or underscore (_) character, and must contain
        only ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at sign (@), equal sign (=),
        and hyphen (-) characters. Can be changed after the virtual server is created.

        Minimum length = 1

    .PARAMETER ServiceGroupName
        The service group name bound to the selected load balancing virtual server.

    .PARAMETER ServiceName
        The service name bound to the selected load balancing virtual server.

    .PARAMETER Weight
        Integer specifying the weight of the service. A larger number specifies a greater weight. Defines the capacity
        of the service relative to the other services in the load balancing configuration. Determines the priority given
        to the service in load balancing decisions.

        Default value: 1
        Minimum value = 1
        Maximum value = 100

    .PARAMETER Force
        Suppress confirmation when binding the service group to the virtual server.

    .PARAMETER Passthru
        Return the binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium', DefaultParameterSetName='servicegroup')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$VirtualServerName = (Read-Host -Prompt 'LB virtual server name'),

        [parameter(Mandatory, ParameterSetName='servicegroup')]
        [string]$ServiceGroupName,

        [parameter(Mandatory, ParameterSetName='serviceservice')]
        [string]$ServiceName,

        [ValidateRange(1, 100)]
        [int]$Weight = 1,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($VirtualServerName, 'Add Virtual Server Binding')) {
            try {

                $params = @{
                    name = $VirtualServerName
                }
                if ($PSBoundParameters.ContainsKey('ServiceGroupName')) {
                    $params.servicegroupname = $ServiceGroupName
                    _InvokeNSRestApi -Session $Session -Method PUT -Type lbvserver_servicegroup_binding -Payload $params
                } elseif ($PSBoundParameters.ContainsKey('ServiceName')) {
                    $params.servicename = $ServiceName
                    $params.weight = $Weight
                    _InvokeNSRestApi -Session $Session -Method PUT -Type lbvserver_service_binding -Payload $params
                }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServerBinding -Session $Session -Name $VirtualServerName
                }
            } catch {
                throw $_
            }
        }
    }
}
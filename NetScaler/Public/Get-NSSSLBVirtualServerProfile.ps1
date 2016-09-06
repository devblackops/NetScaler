<#
Copyright 2016 Iain Brighton

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

function Get-NSLBSSLVirtualServerProfile {
    <#
    .SYNOPSIS
        Gets the specified load balancing virtual server SSL profile object.

    .DESCRIPTION
        Gets the specified load balancing virtual server SSL profile object.

    .EXAMPLE
        Get-NSLBSSLVirtualServerProfile

        Get SSL profiles assigned to all load balancer virtual server objects.

    .EXAMPLE
        Get-NSLBSSLVirtualServerProfile -Name 'vserver01'

        Get the SSL profile assigned to the load balancer virtual server  'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual server to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter(Position = 0)]
        [alias('VirtualServerName')]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            _InvokeNSRestApiGet -Session $Session -Type sslvserver -Name $Name
        }
        catch {
            throw $_
        }
    }
}

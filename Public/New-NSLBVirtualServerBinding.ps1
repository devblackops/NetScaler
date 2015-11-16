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

function New-NSLBVirtualServerBinding {
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string]$VirtualServerName = (Read-Host -Prompt 'LB virtual server name'),

        [parameter(Mandatory = $true)]
        [string]$ServiceGroupName = (Read-Host -Prompt 'LB service group name'),

        [ValidateRange(1, 100)]
        [int]$Weight = 1,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($VirtualServerName, 'New Virtual Server Binding')) {
            $b = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding
            $b.name = $VirtualServerName
            $b.servicegroupname = $ServiceGroupName
            #$b.weight = $Weight

            $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::add($session, $b)
            if ($result.errorcode -ne 0) { throw $result }

            if ($PSBoundParameters.ContainsKey('PassThru')) {
                return Get-NSLBServer -Name $result
            }
        }
    }
}
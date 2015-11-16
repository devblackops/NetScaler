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

function New-NSLBServiceGroupMember {
    <#
    .SYNOPSIS
        Adds a load balancer server to a service group.

    .DESCRIPTION
        Adds a load balancer server to a service group.

    .EXAMPLE
        New-NSLBServiceGroupMember -Name 'sg01' -ServerName 'server01'

        Associates server 'server01' with service group 'sg01'

    .EXAMPLE
        $x = New-NSLBServiceGroupMember -Name 'sg01' -ServerName 'server01' -State 'DISABLED' -PassThru
    
        Associates server 'server01' with service group 'sg01' initially in a DISABLED state and return the object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the service group to associated the server with.

    .PARAMETER ServerName
        The name of the server to attach to the service group.

    .PARAMETER Port
        The port of the server.

    .PARAMETER Weight
        Weight to assign to the server in the service group.

    .PARAMETER ServerId
        The identifier for the service.

    .PARAMETER HashId
        The hash identifier for the service.

    .PARAMETER State
        The initial state of the server in the service group.

    .PARAMETER Passthru
        Return the service group binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias('ServiceGroupName')]
        [string[]]$Name,

        [Parameter(Mandatory = $true)]
        [string[]]$ServerName,

        [ValidateRange(1, 65535)]
        [int]$Port = 80,

        [ValidateRange(1, 100)]
        [int]$Weight = 1,

        [int]$ServerId,

        [ValidateRange(1, [int]::MaxValue)]
        [int]$HashId,

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$State = 'ENABLED',

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            foreach ($member in $ServerName) {
                if ($PSCmdlet.ShouldProcess($item, "Add Service Group Member: $Member")) {
                    $b = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.basic.servicegroup_servicegroupmember_binding
                    $b.servicegroupname = $item
                    $b.servername = $Member
                    $b.port = $Port
                    $b.weight = $Weight
                    $b.state = $State

                    $result = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup_servicegroupmember_binding]::add($session, $b)
                    if ($result.errorcode -ne 0) { throw $result }

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return [com.citrix.netscaler.nitro.resource.config.basic.servicegroup_servicegroupmember_binding]::get($session, $item)
                    }
                }
            }
        }
    }
}


<#
Copyright 2015 Juan C. Herrera

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

function Remove-NSLBServiceGroupMemberBinding {
    <#
    .SYNOPSIS
        Disassociates a load balancer server to a service group.

    .DESCRIPTION
        Disassociates a load balancer server to a service group.

    .EXAMPLE
        Remove-NSLBServiceGroupMember -Name 'sg01' -ServerName 'server01'

        Disassociates server 'server01' from service group 'sg01'

    .EXAMPLE
        $x = Remove-NSLBServiceGroupMember -Name 'sg01' -ServerName 'server01' -State 'DISABLED' -PassThru
    
        Associates server 'server01' with service group 'sg01' initially in a DISABLED state and return the object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the service group to associated the server with.

    .PARAMETER ServerName
        Name of the server to which to bind the service group.

    .PARAMETER IPAddress
        IP Address of the server/resource.        

    .PARAMETER Port
        Server port number.

        Range 1 - 65535

    .PARAMETER Weight
        Weight to assign to the servers in the service group. 
        Specifies the capacity of the servers relative to the other servers in the load balancing configuration. 
        The higher the weight, the higher the percentage of requests sent to the service.

        Minimum value = 1
        Maximum value = 100

    .PARAMETER ServerId
        The identifier for the service. This is used when the persistency type is set to Custom Server ID.

    .PARAMETER HashId
        The hash identifier for the service. This must be unique for each service. 
        This parameter is used by hash based load balancing methods.

        Minimum value = 1

    .PARAMETER State
        The initial state of the server in the service group.

    .PARAMETER Passthru
        Return the service group binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias('ServiceGroupName')]
        [string[]]$Name,

        [Parameter(Mandatory)]
        [string[]]$ServerName,

        [parameter()]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

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
                if ($PSCmdlet.ShouldProcess($item, "Remove Service Group Member: $Member")) {
                    try {
                        $params = @{
                            servicegroupname = $item
                            servername = $member
                            ip = $IPAddress
                            port = $Port
                            weight = $Weight
                            hashid = $HashId
                            state = $State
                        }
                        _InvokeNSRestApi -Session $Session -Method DELETE -Type servicegroup_servicegroupmember_binding -Payload $params -Action delete

                        if ($PSBoundParameters.ContainsKey('PassThru')) {
                            return Get-NSLBServiceGroupMemberBinding -Session $session -Name $item
                        }
                    } catch {
                        throw $_
                    }
                }
            }
        }
    }
}


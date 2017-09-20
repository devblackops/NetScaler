<#
Copyright 2017 Juan C. Herrera

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
        Disassociates a server from a service group.

    .DESCRIPTION
        Disassociates a server from a service group.

    .EXAMPLE
        Remove-NSLBServiceGroupMember -Name 'sg01' -ServerName 'server01' -Port 80

        Disassociates server 'server01' from service group 'sg01'

    .EXAMPLE
        $x = Remove-NSLBServiceGroupMember -Name 'sg01' -ServerName 'server01' -Port 80 -PassThru

        Disassociates server 'server01' with service group 'sg01' and return the object.

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

    .PARAMETER Passthru
        Return the service group binding object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$ServiceName,

        [Parameter(Mandatory)]
        [string[]]$ServerName,

        [Parameter(Mandatory)]
        [ValidateRange(1, 65535)]
        [int]$Port,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $ServiceName) {
            foreach ($member in $ServerName) {
                if ($PSCmdlet.ShouldProcess($item, "Remove Service Group Member: $Member")) {
                    try {
                        $params = @{
                            servicegroupname = $item
                            servername = $ServerName
                            port = $Port
                        }

                        _InvokeNSRestApi -Session $Session -Method DELETE -Type servicegroup_servicegroupmember_binding -Resource $item -Arguments $params -Action delete

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
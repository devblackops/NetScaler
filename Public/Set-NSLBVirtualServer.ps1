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

function Set-NSLBVirtualServer {
    <#
    .SYNOPSIS
        Updates an existing load balancer virtual server.

    .DESCRIPTION
        Updates an existing load balancer virtual server.

    .EXAMPLE
        Set-NSLBVirtualServer -Name 'vserver01' -LBMethod 'ROUNDROBIN'

        Sets the load balancing method for virtual server 'vserver01' to 'ROUNDROBIN'.

    .EXAMPLE
        Set-NSLBVirtualServer -Name 'vserver01' -Comment 'this is a comment' -PassThru
    
        Sets the comment for virtual server 'vserver01' and returns the updated object.

    .EXAMPLE
        Set-NSLBVirtualServer -Name 'vserver01' -IPAddress '11.11.11.11' -Force
    
        Sets the IP address for virtual server 'vserver01' to '11.11.11.11' and suppresses confirmation.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to set.

    .PARAMETER LBMethod
        The load balancing method of the virtual server.

    .PARAMETER IPAddress
        The IP Address of the virtual server.

    .PARAMETER Comment
        The comment associated with the virtual server.

    .PARAMETER Force
        Suppress confirmation when updating a virtual server.

    .PARAMETER Passthru
        Return the virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [ValidateSet('ROUNDROBIN', 'LEASTCONNECTION', 'LEASTRESPONSETIME', 'LEASTBANDWIDTH', 'LEASTPACKETS', 'CUSTOMLOAD', 'LRTM', 'URLHASH', 'DOMAINHASH', 'DESTINATIONIPHASH', 'SOURCEIPHASH', 'TOKEN', 'SRCIPDESTIPHASH', 'SRCIPSRCPORTHASH', 'CALLIDHASH')]
        [string]$LBMethod = 'ROUNDROBIN',

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Virtual Server')) {
                $lb = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.lb.lbvserver
                $lb.Name = $item
                if ($PSBoundParameters.ContainsKey('LBMethod')) {
                    $lb.lbmethod = $LBMethod
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $lb.comment = $Comment
                }
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $lb.ipv46 = $IPAddress
                }

                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::update($session, $lb)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Name $item
                }
            }
        }
    }
}
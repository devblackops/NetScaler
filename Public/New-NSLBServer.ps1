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

function New-NSLBServer {
    <#
    .SYNOPSIS
        Creates a new load balancer server.

    .DESCRIPTION
        Creates a new load balancer server.

    .EXAMPLE
        New-NSLBServer -Name 'server01' -IPAddress '10.10.10.10'

        Creates a new load balancer server named 'server01' with an IP address of '10.10.10.10'.

    .EXAMPLE
        $x = New-NSLBServer -Name 'server01' -IPAddress '10.10.10.10' -State 'DISABLED' -PassThru
    
        Creates a new load balancer server named 'server01' with an initial state of 'DISABLED'
        and returns the newly created object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer servers to create.

    .PARAMETER IPAddress
        The IP Address of the load balancer server.

    .PARAMETER Comment
        The comment associated with the load balancer server.

    .PARAMETER TrafficDomainId
        The traffic domain ID for the server.

    .PARAMETER State
        The initial state of the newly created load balancer server.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

        [ValidateRange(0, 4094)]
        [int]$TrafficDomainId,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$State = 'ENABLED',

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Server')) {
                $s = New-Object -TypeName com.citrix.netscaler.nitro.resource.config.basic.server
                $s.name = $item
                $s.ipaddress = $IPAddress
                $s.comment = $Comment
                $s.td = $TrafficDomainId
                $s.state = $State

                $result = [com.citrix.netscaler.nitro.resource.config.basic.server]::add($session, $s)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServer -Name $item
                }
            }
        }
    }
}
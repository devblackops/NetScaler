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

function Disable-NSLBServer {
    <#
    .SYNOPSIS
        Disable load balancer server object.

    .DESCRIPTION
        Disable load balancer server object.

    .EXAMPLE
        Disable-NSLBServer -Name 'server01'

        Disable the load balancer server 'server01'.

    .EXAMPLE
        'server01', 'server02' | Disable-NSLBServer -Force
    
        Disable the monitors 'monitor01' and 'monitor02' without confirmation.

    .EXAMPLE
        $server = Disable-NSLBServer -Name 'server01' -Force -PassThru

        Disable the load balancer server 'server01' without confirmation and return the resulting object.

    .EXAMPLE
        $server = Disable-NSLBServer -Name 'server01' -Graceful -Delay 60 -Force -PassThru

        Disable the load balancer server 'server01' without confirmation, giving a 60 second grace period before disabling and return the resulting object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer servers to disable.

    .PARAMETER Graceful
        Indicates graceful shutdown of the server. System will wait for all outstanding connections to this server to be closed before disabling the server.

    .PARAMETER Delay
        How many seconds to wait before disabling this server.

    .PARAMETER Force
        Suppress confirmation when disabling the server.

    .PARAMETER PassThru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),
        
        [int]$Delay,

        [int]$Graceful,
        
        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Disable Server')) {
                try {
                    $params = @{
                        name = $item
                    }
                    if ($PSBoundParameters.ContainsKey('Graceful')) {
                        $params.Add('graceful', 'YES')
                        if ($Graceful -gt 0) {
                            $params.Add('delay', $Graceful)
                        } else {
                            if ($PSBoundParameters.ContainsKey('Delay')) {
                                $params.Add('delay', $Delay)
                            } else {
                                $params.Add('delay', 0)
                            }
                        }
                    } else {
                        if ($PSBoundParameters.ContainsKey('Delay')) {
                            if ($Delay -gt 0) {
                                $params.Add('delay', $Delay)
                            }
                        }
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type server -Payload $params -Action disable

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBServer -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
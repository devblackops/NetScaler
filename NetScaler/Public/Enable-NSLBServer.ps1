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

function Enable-NSLBServer {
    <#
    .SYNOPSIS
        Enable load balancer server object.

    .DESCRIPTION
        Enable load balancer server object.

    .EXAMPLE
        Enable-NSLBServer -Name 'server01'

        Enable the load balancer server 'server01'.

    .EXAMPLE
        'server01', 'server02' | Enable-NSLBServer -Force
    
        Enable the monitors 'monitor01' and 'monitor02' without confirmation.

    .EXAMPLE
        $server = Enable-NSLBServer -Name 'server01' -Force -PassThru

        Enable the load balancer server 'server01' without confirmation and return the resulting object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the server.

    .PARAMETER Force
        Suppress confirmation when enabling the server.

    .PARAMETER PassThru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable Server')) {
                try {
                    $params = @{
                        name = $item
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type server -Payload $params -Action enable

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
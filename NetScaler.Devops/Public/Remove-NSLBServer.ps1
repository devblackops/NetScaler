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

function Remove-NSLBServer {
    <#
    .SYNOPSIS
        Removes a load balancer server.

    .DESCRIPTION
        Removes a load balancer server.

    .EXAMPLE
        Remove-NSLBServer -Name 'server01'

        Removes the load balancer server named 'server01'.

    .EXAMPLE
        'server01', 'server02' | Remove-NSLBServer

        Removes the load balancer servers named 'server01' and 'server02'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer server to get.

    .PARAMETER Force
        Suppress confirmation when removing a load balancer server.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Server')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type server -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
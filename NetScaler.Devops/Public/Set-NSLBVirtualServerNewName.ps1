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

function Set-NSLBVirtualServerNewName {
    <#
    .SYNOPSIS
        Updates an existing load balancer virtual server name.

    .DESCRIPTION
        Updates an existing load balancer virtual server name.

    .EXAMPLE
        Set-NSLBVirtualServerNewName -Name 'vserver01' -Newname'ROUNDROBIN'

        Change the load balancing name for 'vserver01' to 'ROUNDROBIN'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to set.

    .PARAMETER Newname
        The load balancing method of the virtual server.

    .PARAMETER Force
        Suppress confirmation when updating a virtual server.

    .PARAMETER Passthru
        Return the virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [ValidateLength(0, 127)]
        [string]$Newname = '',

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Virtual Server')) {
                $params = @{
                    name = $item
                }
                if ($PSBoundParameters.ContainsKey('Newname')) {
                    $params.Add('newname', $Newname)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type lbvserver -Payload $params -Action rename

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Session $Session -Name $item
                }
            }
        }
    }
}
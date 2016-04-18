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

function Set-NSLBServer {
    <#
    .SYNOPSIS
        Updates an existing load balancer server.

    .DESCRIPTION
        Updates an existing load balancer server.

    .EXAMPLE
        Set-NSLBServer -Name 'server01' -IPAddress '10.10.10.10'

        Sets the IP address of the load balancer server named 'server01' to 10.10.10.10.

    .EXAMPLE
        Set-NSLBServer -Name 'server01' -Comment 'this is a comment' -PassThru
    
        Sets the comment for load balancer server 'server01' and returns the updated object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer servers to set.

    .PARAMETER IPAddress
        The IP Address of the load balancer server.

    .PARAMETER Comment
        The comment associated with the load balancer server.

    .PARAMETER Force
        Suppress confirmation when updating a load balancer server.

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Server')) {
                $params = @{
                    name = $Name
                }
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $params.Add('ipaddress', $IPAddress)
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $params.Add('comment', $Comment)
                }
                _InvokeNSRestApi -Session $Session -Method PUT -Type server -Payload $params -Action update

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServer -Session $Session -Name $item
                }
            }
        }
    }
}
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

function Set-NSLBSSLVirtualServer {
    <#
    .SYNOPSIS
        Updates an existing load balancer virtual server.

    .DESCRIPTION
        Updates an existing load balancer virtual server.

    .EXAMPLE
        Set-NSLBSSLVirtualServer -Name 'vserver01' -SSLProfile 'secure'

        Sets the SSL profile for virtual server 'vserver01' to 'secure'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to set.

    .PARAMETER SSLProfile
        Name of the SSL profile that contains SSL settings for the virtual server.

    .PARAMETER Passthru
        Return the virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'LB virtual server name'),

        [string]$SSLProfile,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Edit Virtual Server')) {
                $params = @{
                    vservername = $item
                }

                if ($PSBoundParameters.ContainsKey('SSLProfile')) {
                    $params.Add('sslprofile', $SSLProfile)
                }

                _InvokeNSRestApi -Session $Session -Method PUT -Type sslvserver -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBSSLVirtualServer -Session $Session -Name $item
                }
            }
        }
    }
}
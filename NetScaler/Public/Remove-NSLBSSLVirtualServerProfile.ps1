<#
Copyright 2016 Iain Brighton

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

function Remove-NSLBSSLVirtualServerProfile {
    <#
    .SYNOPSIS
        Remove the existing load balancing virtual server SSL profile.

    .DESCRIPTION
        Remove the existing load balancing virtual server SSL profile.

    .EXAMPLE
        Remove-NSLBSSLVirtualServerProfile -Name 'vserver01' -ProfileName 'sslprofile01'

        Sets the 'vserver01' load balancing virtual server's SSL profile to 'sslprofile01'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the load balancer virtual servers to set.

    .PARAMETER ProfileName
        The SSL profile name to assign to the virtual server.

    .PARAMETER Force
        Suppress confirmation when updating a virtual server.

    .PARAMETER Passthru
        Return the virtual server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [alias('VirtualServerName')]
        [string[]]$Name,

        [parameter(Mandatory = $true, ValueFromPipelineByPropertyName)]
        [string]$ProfileName,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Virtual Server')) {
                try {
                    $params = @{
                        vservername = $item
                        sslprofile = $ProfileName
                    }

                    _InvokeNSRestApi -Session $Session -Method POST -Type sslvserver -Payload $params -Action unset

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSLBVirtualServerSslProfile -Session $Session -Name $item
                    }
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

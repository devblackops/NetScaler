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

function Remove-NSLBSSLProfileToVserverBinding {
    <#
    .SYNOPSIS
        Unbind a ssl profile from a vserver

    .DESCRIPTION
        Unbind a ssl profile from a vserver

    .EXAMPLE
        Remove-NSLBSSLProfileToVserverBinding -VirtualServerName 'somevserver' -SSLProfile 'somesslprofile'

        Unbind ssl profile 'somesslprofile' from vserver 'somevserver'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name of the SSL virtual server for which to set advanced configuration.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [string]$VirtualServerName,

        [Parameter(Mandatory)]
        [bool]$SSLProfile = $false

    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($VirtualServerName, "Unbind ssl profile from virtual Server $VirtualServerName")) {
            try {
                 $params = @{
                    sslprofile = $SSLProfile
                    vservername = $VirtualServerName
                }
                $response = _InvokeNSRestApi -Session $Session -Method POST -Type sslvserver -Payload $params -Action unset
                $response
            }
            catch {
                throw $_
            }
        }
    }
}

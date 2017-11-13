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

function Add-NSLBSSLProfileToVserverBinding {
    <#
    .SYNOPSIS
        Bind a ssl profile bound to a vserver

    .DESCRIPTION
        Bind a ssl profile bound to a vserver

    .EXAMPLE
        Add-NSLBSSLProfileToVserverBinding -VirtualServerName 'somevserver' -SSLProfile 'somesslprofile'

        Binds the ssl profile 'somesslprofile' to vserver 'somevserver'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name of the SSL virtual server for which to set advanced configuration.

    .PARAMETER SSLProfile
        SSL profile associated to vserver.
        Minimum length = 1
        Maximum length = 127
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [string]$VirtualServerName,

        [Parameter(Mandatory)]
        [ValidateLength(1,127)]
        [string]$SSLProfile
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($VirtualServerName, "Bind ssl profile $SSLProfile to virtualserver $VirtualServerName")) {
            try {
                 $params = @{
                    sslprofile = $SSLProfile
                    vservername = $VirtualServerName
                }
                $response = _InvokeNSRestApi -Session $Session -Method PUT -Type sslvserver -Payload $params -Action add
                $response
            }
            catch {
                throw $_
            }
        }
    }
}

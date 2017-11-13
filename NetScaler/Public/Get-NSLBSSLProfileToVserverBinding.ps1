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

function Get-NSLBSSLProfileToVserverBinding {
    <#
    .SYNOPSIS
        Display ssl profile bound to a vserver

    .DESCRIPTION
        Display ssl profile bound to a vserver

    .EXAMPLE
        Get-NSLBSSLProfileToVserverBinding -VirtualServerName somevserver

        Retrieve the ssl profile bound to 'somevserver' vserver

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name of the SSL virtual server for which to set advanced configuration.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory)]
        [string]$VirtualServerName
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($VirtualServerName, 'Retrieve ssl profile bound (or not) to a virtualserver')) {
            try {
                 $params = @{
                    vservername = $VirtualServerName
                }
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type sslvserver -Resource $VirtualServerName
                $response.sslvserver
            }
            catch {
                throw $_
            }
        }
    }
}

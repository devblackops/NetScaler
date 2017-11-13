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

function Add-NSLBSSLVirtualServerCipherGroupBinding {
     <#
    .SYNOPSIS
        Adds a new load balancer server to cipher group binding.

    .DESCRIPTION
        Adds a new load balancer server to cipher group binding.

    .EXAMPLE
        Add-NSLBSSLVirtualServerCipherGroupBinding -VirtualServerName 'vserver01' -CipherName 'somecipher'

        Adds the binding of the SSL cipher group 'somecipher' to virtual server 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name of the SSL virtual server

    .PARAMETER CipherName
        The cipher group/alias/individual cipher configuration.

    .PARAMETER Passthru
        Return the load balancer server object.

    .PARAMETER Force
        Suppress confirmation adding certificate binding.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium', DefaultParameterSetName='servicegroup')]
    param(
        $Session = $script:session,

        [parameter(Mandatory=$True)]
        [string]$VirtualServerName = (Read-Host -Prompt 'LB virtual server name'),

        [parameter(Mandatory=$True)]
        [string]$CipherName,

        [Switch]$PassThru,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($VirtualServerName, 'Add a Cipher Group Binding')) {
            try {

                $params = @{
                    vservername = $VirtualServerName
                    ciphername = $CipherName
                }

                _InvokeNSRestApi -Session $Session -Method PUT -Type sslvserver_sslcipher_binding -Payload $params -action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBSSLVirtualServerCipherGroupBinding -Session $Session -VirtualServerName $VirtualServerName
                }
            } catch {
                throw $_
            }
        }
    }
}
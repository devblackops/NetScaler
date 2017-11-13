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

function Remove-NSLBSSLVirtualServerCipherGroupBinding {
     <#
    .SYNOPSIS
        Unbinds a new load balancer cipher group binding.

    .DESCRIPTION
        Unbinds a new load balancer cipher group binding.

    .EXAMPLE
        Remove-NSLBSSLVirtualServerCipherGroupBinding -VirtualServerName 'vserver01' -Ciphername 'somecipher'

        Unbinds the SSL cipher group 'somecipher' from the virtual server 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        Name of the SSL virtual server

    .PARAMETER CipherName
        Name of the individual cipher, user-defined cipher group, or predefined (built-in) cipher alias.

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
        if ($Force -or $PSCmdlet.ShouldProcess($VirtualServerName, 'Removes Cipher Suite Binding')) {
            try {

                $params = @{
                    vservername = $VirtualServerName
                    ciphername = $CipherName
                }

                _InvokeNSRestApi -Session $Session -Method DELETE -Type sslvserver_sslcipher_binding -Resource $VirtualServerName -Arguments $params -Action delete

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBSSLVirtualServerCipherGroupBinding -Session $Session -VirtualServerName $VirtualServerName
                }
            } catch {
                throw $_
            }
        }
    }
}
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

function Get-NSLBSSLVirtualServerCertificateBinding {
    <#
    .SYNOPSIS
        Gets the specified load balancer SSL virtual server object.

    .DESCRIPTION
        Gets the specified load balancer SSL virtual server object.

    .EXAMPLE
        Get-NSLBSSLVirtualServerCertificateBinding

        Get certificate bindings for all load balancer SSL virtual server objects.

    .EXAMPLE
        Get-NSLBSSLVirtualServerCertificateBinding -VirtualServerName 'vserver01'

        Get the certificate bindings for the load balancer SSL virtual server named 'vserver01'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER VirtualServerName
        The name or names of the load balancer SSL virtual server to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter(Position=0)]
        [string]$VirtualServerName
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        # If we specified a virtual server name, return only those details
        # Otherwise, get everything
        if ($PSBoundParameters.ContainsKey('VirtualServerName')) {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type sslvserver_sslcertkey_binding -Action Get -Resource $VirtualServerName
        } else {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type sslvserver_sslcertkey_binding -Action Get
        }

        if ($response.errorcode -ne 0) { throw $response }

        if ($response.psobject.properties | Where-Object {$_.name -eq 'sslvserver_sslcertkey_binding'}) {
            return $response.sslvserver_sslcertkey_binding
        }
    }
}
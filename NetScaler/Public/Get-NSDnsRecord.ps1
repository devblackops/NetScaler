<#
Copyright 2018 Iain Brighton

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

function Get-NSDnsRecord {
    <#
    .SYNOPSIS
        Gets the specified DNS host/address record.

    .DESCRIPTION
        Gets the specified DNS host/address record.
    
    .EXAMPLE
        Get-NSDnsRecord

        Get all DNS host/address records.

    .EXAMPLE
        Get-NSDnsRecord -Hostname 'storefront.lab.local'

        Get the DNS revord object named 'storefront.lab.local'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Hostname
        The name or names of the DNS suffixes to get.
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Hostname = @()
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        try {
            if ($Hostname.Count -gt 0) {
                foreach ($item in $Hostname) {
                    $response = _InvokeNSRestApi -Session $Session -Method Get -Type dnsaddrec -Resource $item -Action Get
                    if ($response.errorcode -ne 0) { throw $response }
                    if ($Response.psobject.properties.name -contains 'dnsaddrec') {
                        $response.dnsaddrec
                    }
                }
            } else {
                $response = _InvokeNSRestApi -Session $Session -Method Get -Type dnsaddrec -Action Get
                if ($response.errorcode -ne 0) { throw $response }
                if ($Response.psobject.properties.name -contains 'dnsaddrec') {
                    $response.dnsaddrec
                }
            }
        }
        catch {
            throw $_
        }
    }
}

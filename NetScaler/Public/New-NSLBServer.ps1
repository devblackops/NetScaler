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

function New-NSLBServer {
    <#
    .SYNOPSIS
        Creates a new load balancer server.

    .DESCRIPTION
        Creates a new load balancer server.

    .EXAMPLE
        New-NSLBServer -Name 'server01' -IPAddress '10.10.10.10'

        Creates a new load balancer server named 'server01' with an IP address of '10.10.10.10'.

    .EXAMPLE
        $x = New-NSLBServer -Name 'server01' -IPAddress '10.10.10.10' -State 'DISABLED' -PassThru
    
        Creates a new load balancer server named 'server01' with an initial state of 'DISABLED'
        and returns the newly created object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the server. 
    
        Must begin with an ASCII alphabetic or underscore (_) character, and must contain only 
        ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), 
        and hyphen (-) characters. Can be changed after the name is created.
        
        Minimum length = 1

    .PARAMETER IPAddress
        IPv4 or IPv6 address of the server. If you create an IP address based server, you can specify 
        the name of the server, instead of its IP address, when creating a service. 
        
        Note: If you do not create a server entry, the server IP address that you enter when you create 
        a service becomes the name of the server.


    .PARAMETER Domain
        FQDN of the server. If you create a 'Domain Name' type of server, this parameter contains the
        FQDN of the server associated to the NetScaler server resource.

    .PARAMETER Comment
        Any information about the server.

    .PARAMETER TrafficDomainId
        Integer value that uniquely identifies the traffic domain in which you want to configure the entity.
        If you do not specify an ID, the entity becomes part of the default traffic domain, which has an ID of 0.

        Minimum value = 0
        Maximum value = 4094

    .PARAMETER State
        Initial state of the server.
        
        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER Passthru
        Return the load balancer server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB server name'),

        [parameter(Mandatory,ParameterSetName='IPAddress')]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [parameter(Mandatory,ParameterSetName='DomainName')]
        [string]$Domain,

        [ValidateLength(0, 256)]
        [string]$Comment = [string]::Empty,

        [ValidateRange(0, 4094)]
        [int]$TrafficDomainId,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$State = 'ENABLED',

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create Server')) {
                try {
                    $params = @{
                        name = $item
                        comment = $Comment
                        ipaddress = $IPAddress
                        state = $State
                    }
                    if ($PSBoundParameters.ContainsKey('TrafficDomainId')) {
                        $params.Add('td', $TrafficDomainId)
                    }
                    if ($PSBoundParameters.ContainsKey('Domain')) {
                        $params.Add('domain', $Domain)
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type server -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return (Get-NSLBServer -Session $session -Name $item)
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
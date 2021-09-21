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

function Add-NSIPResource {
    <#
    .SYNOPSIS
        Add an IP resource to the NetScaler appliance.

    .DESCRIPTION
        Add an IP resource to the NetScaler appliance.

    .EXAMPLE
        Add-NSIPResource -IPAddress '10.10.10.10' -SubNetMask '255.255.255.0'

        Add IP address 10.10.10.10 to NetScaler.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER IPAddress
        IPv4 address to create on the NetScaler appliance.

        Note: Cannot be changed after the IP address is created

    .PARAMETER SubnetMask
        Subnet mask associated with the IP address.

    .PARAMETER Type
        Type of the IP address to create on the NetScaler appliance. Cannot be changed after the IP address is created.

        The following are the different types of NetScaler owned IP addresses:

        * A Subnet IP (SNIP) address is used by the NetScaler ADC to communicate with the servers.
        The NetScaler also uses the subnet IP address when generating its own packets, such as packets related to dynamic routing
        protocols, or to send monitor probes to check the health of the servers.

        * A Virtual IP (VIP) address is the IP address associated with a virtual server. It is the IP address to which clients connect.
        An appliance managing a wide range of traffic may have many VIPs configured. Some of the attributes of the VIP address are
        customized to meet the requirements of the virtual server.

        * A GSLB site IP (GSLBIP) address is associated with a GSLB site. It is not mandatory to specify a GSLBIP address when you
        initially configure the NetScaler appliance. A GSLBIP address is used only when you create a GSLB site.

        * A Cluster IP (CLIP) address is the management address of the cluster. All cluster configurations must be performed by
        accessing the cluster through this IP address.

        Default value: SNIP
        Possible values = SNIP, VIP, NSIP, GSLBsiteIP, CLIP

    .PARAMETER VServer
        Use this option to set (enable or disable) the virtual server attribute for this IP address.

        Default value: ENABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER MgmtAccess
        Allow access to management applications on this IP address.

        Default value: DISABLED
        Possible values = ENABLED, DISABLED
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string[]]$IPAddress = (Read-Host -Prompt 'IP resource'),

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$SubnetMask = (Read-Host -Prompt 'Subnet mask'),

        [ValidateSet("SNIP", "VIP", "MIP", "NSIP", "GSLBsiteIP", "CLIP")]
        [string]$Type = 'SNIP',

        [switch]$VServer,

        [switch]$MgmtAccess
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $IPAddress) {
            if ($PSCmdlet.ShouldProcess($item, 'Add IP resource')) {
                try {
                    $params = @{
                        ipaddress = $ipaddress
                        netmask = $SubnetMask
                        type = $Type
                        vserver = if ($PSBoundParameters.ContainsKey('VServer')) { 'ENABLED' } else { 'DISABLED' }
                        mgmtaccess = if ($PSBoundParameters.ContainsKey('MgmtAccess')) { 'ENABLED' } else { 'DISABLED' }
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type nsip -Payload $params -Action add > Out-Null
                } catch {
                    throw $_
                }
            }
        }
    }
}
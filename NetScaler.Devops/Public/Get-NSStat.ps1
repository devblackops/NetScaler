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

function Get-NSStat {
    <#
    .SYNOPSIS
        Gets the specified stat object.

    .DESCRIPTION
        Gets the specified stat object.

    .EXAMPLE
        Get-NSStat -Type 'lbvserver'

        Get all stats of type lbvserver

    .EXAMPLE
        Get-NSStat -Type 'servicegroup' -Name 'sg01'

        Get the stats for service group with name sg01

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Type
        The type of stat object to retrieve

    .PARAMETER Name
        The name or names of specific stat objects to retrieve
    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [ValidateSet('aaa', 'appflow', 'appfw', 'appfwpolicy', 'appfwpolicylabel', 'appfwprofile', 'appqoe', 'appqoepolicy',
            'audit', 'authenticationloginschemapolicy', 'authenticationpolicy', 'authenticationpolicylabel', 'authenticationsamlidpolicy',
            'authenticationvserver', 'authorizationpolicylabel', 'autoscalepolicy', 'service', 'servicegroup', 'servicegroupmember',
            'ca', 'cache', 'cachecontentgroup', 'cachepolicy', 'cachepolicylabel', 'clusterinstance', 'clusternode', 'cmp', 'cmppolicy',
            'cmppolicylabel', 'crvserver', 'cvserver', 'dns', 'dnspolicylabel', 'dnsrecords', 'dos', 'dospolicy', 'feo', 'gslbdomain', 'gslbservice',
            'gslbsite', 'dslbvserver', 'hanode', 'icapolicy', 'ipseccounters', 'lbvserver', 'lldp', 'lsn', 'lsndslite', 'lsngroup', 'lsnnat64',
            'mediaclassification', 'interface', 'bridge', 'inat', 'inatsession', 'nat64', 'rnat', 'rnatip', 'tunnelip', 'tunnelip6', 'vlan', 'vpath',
            'vxlan', 'ns', 'nsacl', 'nsacl6', 'nslimitidentifier', 'nsmemory', 'nspartition', 'nspbr', 'nssimpleacl', 'nssimpleacl6',
            'nstrafficdomain', 'pq', 'pqpolicy', 'protocolhttp', 'protocolicmp', 'protocolicmpv6', 'protocolip', 'protocolipv6', 'protocoltcp',
            'ptotocoludp', 'qos', 'rewritepolicy', 'rewritepolicylabel', 'responderpolicy', 'responderpolicylabel', 'sc', 'scpolicy', 'snmp',
            'spilloverpolicy', 'ssl', 'sslvserver', 'streamidentifier', 'system', 'systembw', 'systemcpu', 'systemmemory', 'tmsessionpolicy',
            'tmtrafficpolicy', 'transformpolicy', 'transformpolicylabel', 'vpn', 'vpnvserver', 'pcpserver')]
        [parameter(Mandatory, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Type,

        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
        $stats = @()
    }

    process {
        foreach ($statType in $Type) {
            if ($Name.Count -gt 0) {
                foreach ($item in $Name) {
                    $stats = _InvokeNSRestApi -Session $Session -Method Get -Type $statType -Stat -Resource $item
                    if ($stats | Get-Member -MemberType NoteProperty | Where-Object {$_.name -eq $statType}) {
                        $stats.$statType
                    }
                }
            } else {
                $stats = _InvokeNSRestApi -Session $Session -Method Get -Type $statType -Stat
                if ($stats | Get-Member -MemberType NoteProperty | Where-Object {$_.name -eq $statType}) {
                    $stats.$statType
                }
            }
        }
    }
}

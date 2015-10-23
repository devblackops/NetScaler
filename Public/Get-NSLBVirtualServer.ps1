function Get-NSLBVirtualServer {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [Parameter(Position=0)]
        [string]$Name,

        [int]$Port,

        [ValidateSet('DHCPRA','DIAMTER', 'DNS', 'DNS_TCP', 'DLTS', 'FTP', 'HTTP', 'MSSQL', 'MYSQL', 'NNTP', 'PUSH','RADIUS', 'RDP', 'RTSP', 'SIP_UDP', 'SSL', 'SSL_BRIDGE', 'SSL_DIAMETER', 'SSL_PUSH', 'SSL_TCP', 'TCP', 'TFTP', 'UDP')]
        [string]$ServiceType,

        [ValidateSet('ROUNDROBIN', 'LEASTCONNECTION', 'LEASTRESPONSETIME', 'LEASTBANDWIDTH', 'LEASTPACKETS', 'CUSTOMLOAD', 'LRTM', 'URLHASH', 'DOMAINHASH', 'DESTINATIONIPHASH', 'SOURCEIPHASH', 'TOKEN', 'SRCIPDESTIPHASH', 'SRCIPSRCPORTHASH', 'CALLIDHASH')]
        [string]$LBMethod
    )

    begin {
        _AssertSessionActive
        $virtualServers = @()
    }

    process {
        # Contruct a filter array if we specified any filters
        [com.citrix.netscaler.nitro.util.filtervalue[]] $filters = @()
        if ($PSBoundParameters.ContainsKey('Name')) {
            $filters += New-Object com.citrix.netscaler.nitro.util.filtervalue('name', $Name)
        }
        if ($PSBoundParameters.ContainsKey('Port')) {
            $filters += New-Object com.citrix.netscaler.nitro.util.filtervalue('port', $Port)
        }
        if ($PSBoundParameters.ContainsKey('ServiceType')) {
            $filters += New-Object com.citrix.netscaler.nitro.util.filtervalue('servicetype', $ServiceType)
        }
        if ($PSBoundParameters.ContainsKey('LBMethod')) {
            $filters += New-Object com.citrix.netscaler.nitro.util.filtervalue('lbmethod', $LBMethod)
        }

        # If we specified any filters, filter based on them
        # Otherwise, get everything        
        if ($filters.count -gt 0) {
            $virtualServers = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::get_filtered($Session, $filters)
        } else {
            $virtualServers = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::get($Session)
        }

        $virtualServers
    }
}
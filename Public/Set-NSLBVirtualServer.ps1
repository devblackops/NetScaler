function Set-NSLBVirtualServer {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [ValidateSet('ROUNDROBIN', 'LEASTCONNECTION', 'LEASTRESPONSETIME', 'LEASTBANDWIDTH', 'LEASTPACKETS', 'CUSTOMLOAD', 'LRTM', 'URLHASH', 'DOMAINHASH', 'DESTINATIONIPHASH', 'SOURCEIPHASH', 'TOKEN', 'SRCIPDESTIPHASH', 'SRCIPSRCPORTHASH', 'CALLIDHASH')]
        [string]$LBMethod = 'ROUNDROBIN',

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Virtual Server')) {
                $lb = New-Object com.citrix.netscaler.nitro.resource.config.lb.lbvserver
                $lb.Name = $item
                if ($PSBoundParameters.ContainsKey('LBMethod')) {
                    $lb.lbmethod = $LBMethod
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $lb.comment = $Comment
                }
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $lb.ipv46 = $IPAddress
                }

                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::update($session, $lb)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Name $item
                }
            }
        }
    }
}
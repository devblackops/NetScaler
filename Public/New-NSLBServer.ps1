function New-NSLBServer {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string[]]$Name,

        [parameter(Mandatory)]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

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
                $s = New-Object com.citrix.netscaler.nitro.resource.config.basic.server
                $s.name = $item
                $s.ipaddress = $IPAddress
                $s.comment = $Comment
                $s.td = $TrafficDomainId
                $s.state = $State

                $result = [com.citrix.netscaler.nitro.resource.config.basic.server]::add($session, $s)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServer -Name $item
                }
            }
        }
    }
}
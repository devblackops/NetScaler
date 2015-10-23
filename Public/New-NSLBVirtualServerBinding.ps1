function New-NSLBVirtualServerBinding {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true)]
        [string]$VirtualServerName,

        [parameter(Mandatory = $true)]
        [string]$ServiceGroupName,

        [ValidateRange(1, 100)]
        [int]$Weight = 1,

        [Switch]$Force,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($VirtualServerName, 'New Virtual Server Binding')) {
            $b = New-Object com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding
            $b.name = $VirtualServerName
            $b.servicegroupname = $ServiceGroupName
            #$b.weight = $Weight

            $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::add($session, $b)
            if ($result.errorcode -ne 0) { throw $result }

            if ($PSBoundParameters.ContainsKey('PassThru')) {
                return Get-NSLBServer -Name $item
            }
        }
    }
}
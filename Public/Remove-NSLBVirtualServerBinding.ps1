function Remove-NSLBVirtualServerBinding {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Virtual Server Binding')) {
                try {
                    $binding = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::get($Session, $item)
                    $b = New-Object com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding
                    $b.name = $binding.name
                    $b.servicegroupname = $binding.servicegroupname
                    $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::delete($Session, $b)
                    if ($result.errorcode -ne 0) { throw $result }
                } catch {
                    throw $_
                }
            }
        }
    }
}
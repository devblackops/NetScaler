function Remove-NSLBMonitor {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('MonitorName')]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Monitor')) {
                try {
                    $m = Get-NSLBMonitor -Name $item
                    $result = [com.citrix.netscaler.nitro.resource.config.lb.lbmonitor]::delete($Session, $m)
                } catch {
                    throw $_
                }
                if ($result.errorcode -ne 0) { throw $result }
            }
        }
    }
}
function Get-NSLBMonitor {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        $monitors = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $monitors = [com.citrix.netscaler.nitro.resource.config.lb.lbmonitor]::get($Session, $item)
                $monitors
            }
        } else {
            $monitors = [com.citrix.netscaler.nitro.resource.config.lb.lbmonitor]::get($Session)
            $monitors
        }
    }
}
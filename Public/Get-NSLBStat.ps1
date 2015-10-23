function Get-NSLBStat {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        $stats = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $stats = [com.citrix.netscaler.nitro.resource.stat.lb.lbvserver_stats]::get($session, $item)
                $stats
            }
        } else {
            $stats = [com.citrix.netscaler.nitro.resource.stat.lb.lbvserver_stats]::get($session)
            $stats
        }
    }
}
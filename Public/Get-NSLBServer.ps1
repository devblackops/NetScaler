function Get-NSLBServer {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        $servers = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $servers = [com.citrix.netscaler.nitro.resource.config.basic.server]::get($Session, $item)
                $servers
            }
        } else {
            $servers = [com.citrix.netscaler.nitro.resource.config.basic.server]::get($Session)
            $servers
        }
    }
}
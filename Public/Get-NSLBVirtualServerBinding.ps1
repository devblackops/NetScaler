function Get-NSLBVirtualServerBinding {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        $bindings = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $bindings = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::get($Session, $item)
                $bindings
            }
        } else {
            $vServers = Get-NSLBVirtualServer
            foreach ($item in $vServers) {
                $bindings = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver_servicegroup_binding]::get($Session, $item.name)
                $bindings
            }
        }
    }
}
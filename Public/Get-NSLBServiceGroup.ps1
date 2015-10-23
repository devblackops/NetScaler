function Get-NSLBServiceGroup {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name
    )

    begin {
        _AssertSessionActive
        $serviceGroups = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $serviceGroups = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup]::get($Session, $item)
                $serviceGroups
            }
        } else {
            $serviceGroups = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup]::get($Session)
            $serviceGroups
        }
    }
}
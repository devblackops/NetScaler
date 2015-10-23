function Remove-NSLBServiceGroup {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [Alias('servicegroupname')]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Service Group')) {
                try {
                    $result = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup]::delete($Session, $item)
                } catch {
                    throw $_
                }
                if ($result.errorcode -ne 0) { throw $result }
            }
        }
    }
}
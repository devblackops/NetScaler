function Remove-NSLBVirtualServer {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Virtual Server')) {
                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::delete($Session, $item)
                if ($result.errorcode -ne 0) { throw $result }
            }
        }
    }
}
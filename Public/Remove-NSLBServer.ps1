function Remove-NSLBServer {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Server')) {
                try {
                    $result = [com.citrix.netscaler.nitro.resource.config.basic.server]::delete($Session, $item)
                } catch {
                    throw $_
                }
                if ($result.errorcode -ne 0) { throw $result }
            }
        }
    }
}
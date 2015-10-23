function Enable-NSLBVirtualServer {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable Virtual Server')) {
                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbvserver]::enable($Session, $item)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBVirtualServer -Name $item
                }
            }
        }
    }
}
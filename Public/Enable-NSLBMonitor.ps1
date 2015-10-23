#
#Doesn't work yet
#
function Enable-NSLBMonitor {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('MonitorName')]
        [string[]]$Name,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable Monitor')) {
                $m = Get-NSLBMonitor -Name $item
                $result = [com.citrix.netscaler.nitro.resource.config.lb.lbmonitor]::enable($Session, $m)
                if ($result.errorcode -ne 0) { throw $result }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBMonitor -Name $item
                }
            }
        }
    }
}
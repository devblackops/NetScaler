function Set-NSLBServer {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        $Session = $script:nitroSession,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [ValidateScript({$_ -match [IPAddress]$_ })]
        [string]$IPAddress,

        [ValidateLength(0, 256)]
        [string]$Comment = '',

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Server')) {
                $s = New-Object com.citrix.netscaler.nitro.resource.config.basic.server
                $s.name = $Name
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $s.ipaddress = $IPAddress
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $s.comment = $Comment
                }
                $result = [com.citrix.netscaler.nitro.resource.config.basic.server]::update($session, $s)
                if ($result.errorcode -ne 0) {
                    throw $result
                }

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLBServer -Name $item
                }
            }
        }
    }
}
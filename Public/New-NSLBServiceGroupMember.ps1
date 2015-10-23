function New-NSLBServiceGroupMember {
    [cmdletbinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [Alias('ServiceGroupName')]
        [string[]]$Name,

        [Parameter(Mandatory = $true)]
        [string[]]$ServerName,

        [ValidateRange(1, 65535)]
        [int]$Port,

        [ValidateRange(1, 100)]
        [int]$Weight = 1,

        [int]$ServerId,

        [ValidateRange(1, [int]::MaxValue)]
        [int]$HashId,

        [ValidateSet('ENABLED', 'DISABLED')]
        [string]$State = 'ENABLED',

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {

            $sg = Get-NSLBServiceGroup -Name $item

            foreach ($member in $ServerName) {

                if ($PSCmdlet.ShouldProcess($item, "Add Service Group Member: $Member")) {

                    $b = New-Object com.citrix.netscaler.nitro.resource.config.basic.servicegroup_servicegroupmember_binding
                    $b.servicegroupname = $item
                    $b.servername = $Member
                    $b.port = $Port
                    $b.weight = $Weight
                    $b.state = $State

                    $result = [com.citrix.netscaler.nitro.resource.config.basic.servicegroup_servicegroupmember_binding]::add($session, $b)
                    if ($result.errorcode -ne 0) { throw $result }

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return [com.citrix.netscaler.nitro.resource.config.basic.servicegroup_servicegroupmember_binding]::get($session, $item)
                    }
                }
            }
        }
    }
}


function Get-NSResponderPolicy {
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter(Position=0)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        _InvokeNSRestApiGet -Session $Session -Type responderpolicy -Name $Name
    }
}
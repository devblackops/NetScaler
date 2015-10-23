function Save-NSConfig {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession
    )

    begin {
        _AssertSessionActive
    }

    process {
        $Session.save_config() | Out-Null
    }
}
function Disconnect-NetScaler {
    [cmdletbinding()]
    param()

    _AssertSessionActive

    try {
        $script:nitroSession.logout()
        Write-Verbose -Message "Disconnected from NetScaler"
    } catch {
        throw $_
    }    
}
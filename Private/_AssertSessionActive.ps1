function _AssertSessionActive {
    if ($null -eq $script:nitroSession) {
        throw 'Must be logged into NetScaler appliance first!'
    }
}
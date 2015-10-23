function Connect-NetScaler {
    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [string]$NSIP,

        [parameter(mandatory = $true)]
        [pscredential]$Credential,

        [switch]$Https
    )

    Write-Verbose -Message "Connecting to $NSIP..."

    try {
        if ($PSBoundParameters.ContainsKey('Https')) {
            $script:nitroSession = New-Object com.citrix.netscaler.nitro.service.nitro_service($NSIP, 'https')
        } else {
            $script:nitroSession = New-Object com.citrix.netscaler.nitro.service.nitro_service($NSIP, 'http')
        }
        $script:session = $script:nitroSession.Login($Credential.UserName, $Credential.GetNetworkCredential().Password)
        Write-Verbose -Message "Connecting to $NSIP successfully"
    } catch {
        throw $_
    }    
}
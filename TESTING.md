# Integration testing

## Setup a test netscaler

    $Nsip       = "172.16.124.11"
    $Snip       = "172.16.124.111"
    $DnsIp      = "172.16.124.1"
    $SubnetMask = "255.255.255.0"


    $SecurePassword = ConvertTo-SecureString "nsroot" -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ("nsroot", $SecurePassword)
    Connect-Netscaler -Hostname $Nsip -Credential $Credential
    Add-NSIPResource -Type SNIP -IPAddress $Snip -SubnetMask $SubnetMask
    Set-NSHostname -Hostname ns-test -Force
    Add-NSDnsNameServer -IPAddress $DnsIp
    Set-NSTimeZone -TimeZone "GMT+01:00-CET-Europe/Paris" -Force
    Save-NSConfig
    (Invoke-Nitro -Action get -Type nshardware -Method get).nshardware.Hostname

    # Get a license with the _Host ID_

    Install-NSLicense -Path /Users/dom/Downloads/FID__26d05285_157049a9857_1935.lic -Session $Session
    Restart-NetScaler -Force
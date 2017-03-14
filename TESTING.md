# Integration testing

## Setup a test netscaler

The following commands achieve a minimal NetScaler setup for testing purposes.

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
    (Get-NSHardware).host

    # Get a license with the _Host ID_

    Install-NSLicense -Path /Users/dom/Downloads/my_downloaded_license.lic -Session $Session
    Restart-NetScaler -Force -Wait
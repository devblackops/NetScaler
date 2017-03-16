# Integration testing

## Provisioning

In the following process we assume that the NetScaler _Host ID_ (first MAC address), the _NSIP_ are set in the following variables:

    $HostId     = "000c296641f6"
    $Nsip       = "172.16.124.11"
    $DefaultGw  = "172.16.124.1"

### Download & License

1. Go to https://www.citrix.com/lp/try/netscaler-vpx-platinum.html to generate a license.
1. Go to https://www.citrix.com/content/citrix/en_us/account/toolbox/manage-licenses/allocate.html to activate the license with the NetScaler _Host ID_.
1. Download the license file and save it as license.lic
1. Download the VPX package for your target hypervisor

### VMWare Fusion

The following setup instructions assume MacOSX with VMWare Fusion, but it can easily be
adjusted to your own environment.

1. Download _NetScaler VPX Express_ from https://www.citrix.com/downloads/netscaler-adc/ (a
log in is required, just create a Citrix account)
1. Unzip the downloaded file:
        unzip -x NSVPX-ESX-11.0-69.12_nc.zip -d NSVPX-ESX-11.0-69.12_nc
1. Import either with the VMWare GUI or, if you have OVF tools installed with:
        ovftool --hideEula NSVPX-ESX-11.0-69.12_nc/NSVPX-ESX-11.0-69.12_nc.ovf ~/Documents/Virtual\ Machines.localized/
        vmrun start ~/Documents/Virtual\ Machines.localized/NSVPX-ESX-11.0-69.12_nc.vmwarevm
1. NetScaler should start and after a few seconds you will see the CLI setup wizard.
Enter the IP address you will use to communicate with NetScaler, netmask and default
gateway (ensure the proper VMWare network is configured for the VM).
1. After a few seconds, check that you have access:
        Connect-NetScaler -Hostname <insert IP address here> -Credential (Get-Credential -UserName nsroot)
        Get-NSIPResource

### Hyper-V 

You can use the [New-NSHyperVInstance.ps1](https://github.com/dbroeglin/NetScaler/blob/exp/hyper-auto-provision/Contrib/New-NSHyperVInstance.ps1) to automatically setup a test instance with a single network inteface connected to the `Labnet` virtual switch:

    New-NSHyperVInstance.ps1 -Verbose -Package C:\temp\NSVPX-HyperV-11.1-50.10_nc.zip `
        -VMName NSVPX-11-1 `
        -SwitchName Labnet `
        -MacAddress $HostId `
        -NSIP $Nsip -DefaultGateway $DefaultGateway `
        -Path C:\temp\NSVPX-11-1 `

### Other hypervisors

TODO

## Setup a test NetScaler

The following commands achieve a minimal NetScaler setup for testing purposes.

    $Snip       = "172.16.124.111"
    $DnsIp      = "172.16.124.1"
    $SubnetMask = "255.255.255.0"

    $SecurePassword = ConvertTo-SecureString "nsroot" -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ("nsroot", $SecurePassword)
    Connect-NetScaler -Hostname $Nsip -Credential $Credential
    Add-NSIPResource -Type SNIP -IPAddress $Snip -SubnetMask $SubnetMask
    Set-NSHostname -Hostname ns-test -Force
    Add-NSDnsNameServer -IPAddress $DnsIp
    Set-NSTimeZone -TimeZone "GMT+01:00-CET-Europe/Paris" -Force
    Save-NSConfig

    # To retrieve the host ID if you did not set it during provisioning:
    (Get-NSHardware).host

    Install-NSLicense -Path $HOME/Downloads/my_downloaded_license.lic -Session $Session
    Restart-NetScaler -Force -Wait



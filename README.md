[![Build status](https://ci.appveyor.com/api/projects/status/a6oio0l6g27nhg0w?svg=true)](https://ci.appveyor.com/project/devblackops/netscaler)

# NetScaler

PowerShell module for interacting with Citrix NetScaler via the Nitro API.

This module contains functions that abstract away the nitty-gritty aspects of 
the Nitro API. It provides a set of idiomatic PowerShell functions with 
parameter validation and inline documentation. The module can be used for both
a better command line experience and writing scripts that automate NetScaler
setup.

# Getting started

## Login into NetScaler

This script establishes a session with the NetScaler instance and sets its host name:

```powershell
$Nsip, $Username, $Password = "1.2.3.4", "nsroot", "nsroot"

$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

Set-NSHostname -Hostname ns01 -Force -Session $Session
```

## Initial setup

Once logged into a freshly installed NetScaler, the following script sets up the time zone, 
installs a license, saves the configuration and reboots:

```powershell
Set-NSTimeZone -TimeZone 'GMT+01:00-CET-Europe/Zurich' -Session $Session -Force

Install-NSLicense -Path licenses/license.lic -Session $Session
Restart-NetScaler -WarmReboot -Wait -SaveConfig -Session $Session -Force
```

After reboot, a reconnection is required:

```powershell
$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru
```

## Basic tasks

Once initial setup is done, regular configuration can start. The following commands 
will set up a VIP and SNIP:

```powershell
Add-NSIPResource -Type SNIP -IPAddress 172.16.124.11 -SubNetMask '255.255.255.0' -VServer -Session $Session

Add-NSIPResource -Type VIP  -IPAddress 172.16.124.12 -SubNetMask '255.255.255.0' -VServer -Session $Session
```

This will add a DNS server:

```powershell
Add-NSDnsNameServer -IPAddress 1.2.3.10
```

The line below will enable the following features:
- Authentication, Authorization and Auditing,
- Load balancing,
- Rewrite,
- SSL offloading.

```powershell
Enable-NSFeature -Session $Session -Force -Name "aaa", "lb", "rewrite", "ssl"
```

## Setting up a reverse proxy

The above example deal with setting up the stage. However, to configure NetScaler for some
real work, more complex set of commands is needed. Usually, this kind of work can be abstracted 
in a PowerShell function. For instance, the following function will create a very simple reverse proxy:

```powershell
New-ReverseProxy -IPAddress 172.16.124.12 -ExternalFQDN www.extlab.local -InternalFQDN www.lab.local
```

The actual implementation could be:
```powershell
function New-ReverseProxy {
    Param(
        [String]$IPAddress,
        [String]$ExternalFQDN,
        [String]$InternalFQDN,
        [String]$CertificateName = $ExternalFQDN
    )
    $VServerName = "vsrv-$ExternalFQDN"
    $ServerName = "srv-$InternalFQDN"

    New-NSLBServer -Name $ServerName -Domain $InternalFQDN
    Enable-NSLBServer -Name $ServerName -Force
    New-NSLBServiceGroup -Name svg-$ExternalFQDN -Protocol HTTP
    New-NSLBServiceGroupMember -Name svg-$ExternalFQDN -ServerName $ServerName

    New-NSLBVirtualServer -Name $VServerName -IPAddress $IPAddress -ServiceType SSL -Port 443
    Add-NSLBVirtualServerBinding -VirtualServerName $VServerName -ServiceGroupName svg-$ExternalFQDN
    Enable-NSLBVirtualServer -Name $VServerName -Force

    Add-NSLBSSLVirtualServerCertificateBinding -Certificate $CertificateName -VirtualServerName $VServerName

    New-NSRewriteAction -Name "act-proxy-host-$InternalFQDN" -Type Replace -Target 'HTTP.REQ.HOSTNAME' -Expression "`"$InternalFQDN`""
    New-NSRewritePolicy -Name "pol-proxy-host-$InternalFQDN" -ActionName "act-proxy-host-$InternalFQDN" -Rule "true"
    Add-NSLBVirtualServerRewritePolicyBinding -VirtualServerName $VServerName -PolicyName "pol-proxy-host-$InternalFQDN" `
        -BindPoint Request -Priority 100
}
```

## Beyond the module

Although, the module is still a work in progress, there are already more than 140 functions
implemented. Those functions cover most needs. However, you might occasionally need a Nitro
resource that is not implemented. In that case you can rely on a simple call to `Invoke-Nitro`.
For instance, the following call will set the `nsroot` user's session expiration time to 1 day 
(not recommended in production but very helpful in a development environment!):

```powershell
Invoke-Nitro -Type systemuser -Method PUT -Payload @{
        username     = "nsroot"
        timeout      = "86400"
        logging      = "ENABLED"
        externalauth = "ENABLED"
    } -Action Add -Force
```

## Examples

For a more complete example you can take a look ad [NSConfig.ps1](https://github.com/dbroeglin/windows-lab/blob/master/NSConfig.ps1)

# Similar work

- Carl Stalhood created [a script that configures NetScaler through Nitro](http://www.carlstalhood.com/netscaler-scripting).
- Santiago Cardenas wrote a series of posts about [setting up NetScaler for StoreFront](https://www.citrix.com/blogs/2014/09/19/scripting-automating-netscaler-configurations-using-nitro-rest-api-and-powershell-part-1/) with load balancing and high-availability.
- Esther Barthel has done a few [talks](https://www.citrix.com/blogs/2016/04/29/automate-netscaler-using-nitro-api-and-powershell/) about automating NetScaler configuration through Nitro.



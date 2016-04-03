[![Build status](https://ci.appveyor.com/api/projects/status/a6oio0l6g27nhg0w?svg=true)](https://ci.appveyor.com/project/devblackops/netscaler)

# NetScaler
PowerShell module for interacting with Citrix NetScaler via the Nitro API

# Getting started

This script establishes a session with the Netscaler instance and sets its hostname:

    $Nsip, $Username, $Password = "1.2.3.4", "nsroot", "nsroot"
    
    $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

    $Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru
    
    Set-NSHostname -Hostname ns01 -Force -Session $Session

    # ...
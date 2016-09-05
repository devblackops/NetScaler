## 1.3.0 (unreleased)
  * Features
    * Added Add-NSCSVirtualServerResponderPolicyBinding (via @rokett)
    * Added Add-NSLBSSLVirtualServerCertificateBinding (via @rokett)
    * Added Add-NSLBVirtualServerRewritePolicyBinding (via @rokett)
    * Added Get-NSAAAGroup (via @psminion)
    * Added Get-NSAAAGroupBinding (via @psminion)
    * Added Get-NSAAAUser (via @psminion)
    * Added Get-NSAAAUserBinding (via @psminion)
    * Added Get-NSCSVirtualServerResponderPolicyBinding (via @rokett)
    * Added Get-NSLBServiceGroupMonitorBinding (via @rokett)
    * Added Get-NSLBSSLVirtualServer (via @rokett)
    * Added Get-NSLBSSLVirtualServerCertificateBinding (via @rokett)
    * Added Get-NSLBVirtualServerRewritePolicyBinding (via @rokett)
    * Added New-NSCSVirtualServer (via @rokett)
    * Added New-NSLBServiceGroupMonitor (via @rokett)
    * Added Set-NSLBSSLVirtualServer (via @rokett)

  * Improvements
    * Modified New-NSLBMonitor allow setting HTTP request and expected response codes parameters (via @rokett)
    * Modified New-NSLBVirtualServer to allow setting PersistenceType and PersistenceTimeout parameters (via @rokett)

  * Bug fixes
    * Fixed bug in Add-NSLBVirtualServerBinding where weight was improperly being added when binding to a service group. (via @rokett)
    * Fixed Set-NSHostname and Set-NSTimeZone update actions (via @iainbrighton)
    * Fixed ConvertTo-Json depth in PowerShell 5.1 (via @iainbrighton)

## 1.2.0 (2016-04-19)
  - Added Invoke-Nitro to wrap direct calls to _InvokeNSRestApi
  - Added Get-NSConfig : retrieve NetScaler configuration (running or saved)
  - Added Get/New/Set/Remove-NSResponderAction
  - Modified Get-NSLBMonitor, Get-NSLBServer, Get-NSLBServiceGroup to only return
    resources if there are resources to return.

## 1.1.3 (2016-04-03)
  - Add default parameter set to Connect-NetScaler
  - Fix bad error handling logic in Disconnect-NetScaler
  - Fix bad error handling logic in Get-NSLBServer
  - Fix bug in Get-NSLBVirtualServer when there was nothing to return
  - Modify Get-NSLBVirtualServceBinding to return service AND service group bindings
  - Modify Remove-NSLBVirtualServerBinding to remove services OR service groups
  - Rename New-NSLBVirtualServerBinding to Add-NSLBVirtualServerBinding
  - Add suppport for adding service OR service group bindings to New-NSLBVirtualServerBinding
  - Correct typo in Install-NSLicense
  - Correct typo in New-NSLBServiceGroup/Set-NSLBServiceGroup
  - Add -Force and -PassThru to Set-NSTimeZone
  - Allow any filepath when installing NS license in Install-NSLicense

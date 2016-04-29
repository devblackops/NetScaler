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
    

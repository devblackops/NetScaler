
# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Unreleased
  * Features
    * Added Get-NSRADIUSAuthenticationServer, New-NSRADIUSAuthenticationServer and Remove-NSRADIUSAuthenticationServer functions (via @iainbrighton)
    * Added Get-NSRADIUSAuthenticationPolicy, New-NSRADIUSAuthenticationPolicy and Remove-NSRADIUSAuthenticationPolicy functions (via @iainbrighton)
    * Added -RADIUSAuthenticationPolicyName parameter to Add-NSVPNVirtualServerBinding function (via @iainbrighton)
    * Added RADIUSAuthenticationPolicy -Binding parameter to Get-NSVPNVirtualServerBinding function (via @iainbrighton)
    * Added Get-NSDnsRecord, Add-NSDnsRecord and Remove-NSDnsRecord functions (via @iainbrighton)
    * Added Get-NSTACACSAuthenticationPolicy, New-NSTACACSAuthenticationPolicy and Remove-NSTACACSAuthenticationPolicy functions (via @iainbrighton)
    * Added Get-NSTACACSAuthenticationServer, New-NSTACACSAuthenticationServer and Remove-NSTACACSAuthenticationServer functions (via @iainbrighton)
    * Added LDAP nested group extraction parameters to New-NSLDAPAuthenticationServer (via @iainbrighton)
    * Added RfWebUI option to Set-NSVPNVirtualServerTheme (via @iainbrighton)
    * Added Add-NSAuthenticationPolicyGlobalBinding, Get-NSAuthenticationPolicyGlobalBinding, Remove-NSAuthenticationPolicyGlobalBinding functions (via @iainbrighton)
    * Added Get-NSRDPClientProfile, New-NSRDPClientProfile and Remove-NSRDPClientProfile functions (via @iainbrighton)
    * Added -RDPServerProfileName parameter to New-NSVPNVirtualServer and New-NSVPNSessionProfile (via @iainbrighton)
    * Added Get-NSVPNUrl, New-NSVPNUrl and Remove-NSVPNUrl functions (via @iainbrighton)
    * Added New-NSSAMLAuthenticationPolicy and Remove-NSSAMLAuthenticationPolicy functions (via @iainbrighton)
    * Added New-NSSAMLAuthenticationServer and Remove-NSSAMLAuthenticationServer functions (via @iainbrighton)
    * Added -SAMLAuthenticationPolicyName and -VPNUrlName parameters to Add-NSVPNVirtualServerBinding and Get-NSVPNVirtualServerBinding (via @iainbrighton)

  * Bug fixes
    * Fixed bug where extraneous Out-Null files were created when calling some functions (via @iainbrighton)

## 1.7.0 (2018-07-02)
  * Features
    * PR88 - Add SearchFilter and SubAttributeName parameters to New-NSLDAPAuthenticationServer (via @iainbrighton)

## 1.6.0 (2017-10-31)
  * Features
    * PR82 - Added Get-NSCurrentTime, Get-NSlicenseExpiration, and Update-NSAppliance functions (via @ryancbutler)

## 1.5.0 (2017-07-25)
  * Features
    * PR57 - Added -Graceful parameter to the Disable-NSLBServer (via @daimhin)
    * PR59 - Added New-NSRewriteAction and New-NSRewritePolicy functions (via @dbroeglin)
    * PR61 - Added Clear-NSAAASession function (via @dbroeglin)
    * PR66 - Added Add-NSLBVirtualServerTrafficPolicyBinding and Get-NSLBVirtualServerTrafficPolicyBinding functions (via @dbroeglin)
    * PR72 - Added Get-NSHardware and Remove-NSSystemFile functions (via @daimhin)
    * PR77 - Added Enable-NSHighAvailability and Get-HANode functions (via @dbroeglin)

  * Improvements
    * PR66 - Updated comment-based help for Get-NSLBVirtualServerResponderPolicyBinding and Get-NSLBVirtualServerRewritePolicyBinding (via @dbroeglin)
    * PR78 - Internal improvements to connecting to NetScaler URI (via @dbroeglin)

  * Bug fixes
    * PR68 - Fixed bug in Add-NSCertKeyPair when converting a securestring to plain text using PowerShell v6.0 on Mac OSX. (via @dbroeglin)
    * PR72 - Fix bug in Get-NSSystemFile where FileLocation parameter was not set to mandatory even though the Nitro API requires it (via @dbroeglin)
    * PR75 - Use correct property name when returning monitor before deleting with Remove-NSLBMonitor (via @devblackops)

## 1.4.0 (2016-11-07)
  * Features
    * Added parameters to New-NSLBVirtualServer to configure a redirect (via @rokett)
    * Added parameter 'ICMPVSResponse' to New-NSLBVirtualServer which controler whether ICMP response is ACTIVE or PASSIVE on VIP (via @dbroeglin)
    * Added Add-NSLBVirtualServerResponderPolicyBinding an Get-NSLBVirtualServerResponderPolicyBinding (via @rokett)
    * Added (Get|New|Remove)-NSBackup to manage NetScaler backups (via @devblackops)
    * Added Get-NSStat function to get NetScaler stat objects (via @devblackops)
    * Added New-NSResponderPolicy function to create responder policies (via @rokett)
    * Added -Send and -Recv parameters to New-NSLBMonitor (via @rokett)

  * Improvements
    * Added support for 'Arguments' parameter in _InvokeNsRestApiGet (via @dbroeglin)
    * Refactored Get-NSSystemFile to use internal _InvokeNSRestApiGet function (via @dbroeglin)
    * Added example to comment-based help in _InvokeNSRestApiGet (via @dbroeglin)

  * Bug fixes
    * Fix typo in Add-NSLBVirtualServerBinding (via @rokett)

  * Deprecated
    * Mark Get-NSLBStat as deprecated in favor of Get-NSStat

## 1.3.0 (2016-09-10)
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
    * Added Get-NSVersion (via @iainbrighton)
    * Added Get-NSDnsNameServer (via @iainbrighton)
    * Added Get-NSDnsSuffix, Add-NSDnsSuffix and Remove-NSDnsSuffix (via @iainbrighton)
    * Added Get-NSSSLCertificateLink, Add-NSSSLCertificateLink and Remove-NSSSLCertificateLink (via @iainbrighton)
    * Added Get-NSSSLProfile, New-NSSSLProfile, Set-NSSSLProfile and Remove-NSSSLProfile (via @iainbrighton)
    * Added Add-NSLBServiceGroupMonitorBinding and Remove-NSLBServiceGroupMonitorBinding (via @iainbrighton)
    * Added Get-NSLBSSLVirtualServerProfile, Set-NSLBSSLVirtualServerProfile and Remove-NSLBSSLVirtualServerProfile (via @iainbrighton)
    * Added Get-NSLDAPAuthenticationServer, New-NSLDAPAuthenticationServer and Remove-NSLDAPAuthenticationServer (via @iainbrighton)
    * Added Get-NSLDAPAuthenticationPolicy, New-NSLDAPAuthenticationPolicy and Remove-NSLDAPAuthenticationPolicy (via @iainbrighton
    * Added New-NSVPNVirtualServer (via @iainbrighton)
    * Added Get-NSVPNVirtualServerBinding and Add-NSVPNVirtualServerBinding (via @iainbrighton)
    * Added Get-NSVPNVirtualServerTheme and Set-NSVPNVirtualServerTheme (via @iainbrighton)
    * Added New-NSVPNSessionPolicy and Remove-NSVPNSessionPolicy (via @iainbrighton)
    * Added New-NSVPNSessionProfile and Remove-NSVPNSessionProfile (via @iainbrighton)
    * Added Get-NSTimeZone (via @iainbrighton)

  * Improvements
    * Modified New-NSLBMonitor allow setting HTTP request and expected response codes parameters (via @rokett)
    * Modified New-NSLBVirtualServer to allow setting PersistenceType and PersistenceTimeout parameters (via @rokett)
    * Modified New-NSLBMonitor to support custom monitor properties (via @iainbrighton)
    * Modified Get-NSLBServiceGroupMonitorBinding to support filtering by monitor name (via @iainbrighton)
    * Added -Force parameter to Add-NSLBSSLVirtualServerCertificateBinding to suppress confirmation (via @iainbrighton)
    * Added private _AssertNSVersion to enforce particular versioned APIs, e.g. Get-NSVPNVirtualServerTheme (via @iainbrighton)
    * Modified Set-NSTimeZone to accept pipeline input and return just the configured timezone (via @iainbrighton)
    * Added additional help tests and fixed incorrect help examples/commands (via @iainbrighton)

  * Bug fixes
    * Fixed bug in Add-NSLBVirtualServerBinding where weight was improperly being added when binding to a service group. (via @rokett)
    * Fixed Set-NSHostname and Set-NSTimeZone update actions (via @iainbrighton)
    * Fixed ConvertTo-Json depth in PowerShell 5.1 (via @iainbrighton)
    * Fixed filename rewrite issue in Add-NSSystemFile (via @iainbrighton)
    * Fixed certificate import without private key in Add-NSCertKeyPair (via @iainbrighton)
    * Fixed comment-based help (via @devblackops)
    * Fixed _InvokeNSRestApiGet to filter collections (via @iainbrighton)
    * Fixed bug in Add-NSDnsNameServer where DNSVServerName could not be blank (via @iainbrighton)

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

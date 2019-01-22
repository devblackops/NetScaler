<#
Copyright 2018 Iain Brighton

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

function New-NSRDPClientProfile {
    <#
    .SYNOPSIS
        Create NetScaler Gateway RDP client profile resource.

    .DESCRIPTION
        Create NetScaler Gateway session profile resource.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the rdp profile.

        Minimum length = 1

    .PARAMETER UrlOverride
        This setting determines whether the RDP parameters supplied in the vpn url override those specified in the RDP profile.
        
        Default value: ENABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER RedirectClipboard
       This setting corresponds to the Clipboard check box on the Local Resources tab under Options in RDC.
       
       Default value: ENABLE
       Possible values = ENABLE, DISABLE

    .PARAMETER RedirectDrives
        This setting corresponds to the selections for Drives under More on the Local Resources tab under Options in RDC.
        
        Default value: DISABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER RedirectPrinters
        This setting corresponds to the selection in the Printers check box on the Local Resources tab under Options in RDC.
        
        Default value: ENABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER RedirectComPorts
        This setting corresponds to the selections for comports under More on the Local Resources tab under Options in RDC.
        
        Default value: DISABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER RedirectPnpDevices
        This setting corresponds to the selections for pnpdevices under More on the Local Resources tab under Options in RDC.
        
        Default value: DISABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER KeyboardHook
        This setting corresponds to the selection in the Keyboard drop-down list on the Local Resources tab under Options in RDC.
        
        Default value: InFullScreenMode
        Possible values = OnLocal, OnRemote, InFullScreenMode

    .PARAMETER AudioCaptureMode
        This setting corresponds to the selections in the Remote audio area on the Local Resources tab under Options in RDC.
        
        Default value: DISABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER VideoPlaybackMode
        This setting determines if Remote Desktop Connection (RDC) will use RDP efficient multimedia streaming for video playback.
        
        Default value: ENABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER MultiMonitorSupport
        Enable/Disable Multiple Monitor Support for Remote Desktop Connection (RDC).
        
        Default value: ENABLE
        Possible values = ENABLE, DISABLE

    .PARAMETER CookieValidity
        DP cookie validity period.<br>Default value: 60
        
        Minimum value = 60
        Maximum value = 86400

    .PARAMETER AddUsernameInRDPFile
        Add username in rdp file.
        
        Default value: NO
        Possible values = YES, NO

    .PARAMETER RDPFileName
        RDP file name to be sent to End User.
        
        Minimum length = 1

    .PARAMETER RDPHost
        Fully-qualified domain name (FQDN) of the RDP Listener.
        
        Maximum length = 252

    .PARAMETER RDPListener
        Fully-qualified domain name (FQDN) of the RDP Listener with the port in the format FQDN:Port.
        
        Maximum length = 258

    .PARAMETER CustomParameters
        Option for RDP custom parameters settings (if any). Custom params needs to be separated by &
        
        Default value: 0
        Minimum length = 1

    .PARAMETER PreSharedKey
        Pre shared key value.
        
        Default value: 0

    .PARAMETER Passthru
        Return the NetScaler Gateway session profile object.

    .PARAMETER Force
        Suppress confirmation when creating the NetScaler Gateway RDP client profile.

    .EXAMPLE
        New-NSRDPClientProfile -Session $Session -Name 'profile_rdp_client' -UrlOverride DISABLE

        Creates a new NetScaler Gateway RDP client profile named 'profile_rdp_client'.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory)]
        [string] $Name,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $UrlOverride,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $RedirectClipboard,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $RedirectDrives,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $RedirectPrinters,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $RedirectComPorts,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $RedirectPnpDevices,

        [ValidateSet('OnLocal', 'OnRemote', 'InFullScreenMode')]
        [string] $KeyboardHook,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $AudioCaptureMode,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $VideoPlaybackMode,

        [ValidateSet('ENABLE', 'DISABLE')]
        [string] $MultiMonitorSupport,

        [ValidateRange(60, 86400)]
        [int] $CookieValidity,

        [ValidateSet('ON', 'OFF')]
        [string] $AddUsernameInRDPFile,

        [string] $RDPFileName,

        [string] $RDPHost,

        [string] $RDPListener,

        [string] $CustomParameters,

        [string] $PreSharedKey,

        [switch] $Force,

        [switch] $PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force  -or $PSCmdlet.ShouldProcess($Name, "Add RDP client profile")) {
            try {
                $propertyMap = @{
                    UrlOverride          = 'rdpurloverride'
                    RedirectClipboard    = 'redirectclipboard'
                    RedirectDrives       = 'redirectdrives'
                    RedirectPrinters     = 'redirectprinters'
                    RedirectComPorts     = 'redirectcomports'
                    RedirectPnpDevices   = 'redirectpnpdevices'
                    KeyboardHook         = 'keyboardhook'
                    AudioCaptureMode     = 'audiocapturemode'
                    VideoPlaybackMode    = 'videoplaybackmode'
                    MultiMonitorSupport  = 'multimonitorsupport'
                    CookieValidity       = 'rdpcookievalidity'
                    AddUsernameInRDPFile = 'addusernameinrdpfile'
                    RDPFileName          = 'rdpfilename'
                    RDPHost              = 'rdphost'
                    RDPListener          = 'rdplistener'
                    CustomParameters     = 'rdpcustomparams'
                    PreSharedKey         = 'psk'
                }
                $params = @{
                    name = $Name
                }

                foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
                    if ($propertyMap.ContainsKey($parameter.Key)) {
                        $params[$propertyMap[$parameter.Key]] = $parameter.Value
                    }
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type rdpclientprofile -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSRDPClientProfile -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

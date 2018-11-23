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

function New-NSRADIUSAuthenticationServer {
    <#
    .SYNOPSIS
        Creates a new RADIUS authentication server object.

    .DESCRIPTION
        Creates a new RADIUS authentication server object.

    .EXAMPLE
        New-NSRADIUSAuthenticationServer -Name NPS01 -ServerName nps01.lab.local -SharedSecret 'abcd1234'

        Creates a new RADIUS authentication server called 'NPS01', pointing to host 'nps01.lab.local' using the shared secret of 'abcd1234'

    .EXAMPLE
        New-NSRADIUSAuthenticationServer -Name NPS01 -ServerName nps01.lab.local -SharedSecret 'abcd1234' -NASID 'MFA'

        Creates a new RADIUS authentication server called 'NPS01', pointing to host 'nps01.lab.local' using the shared secret of 'abcd1234' and Network Access Server ID of 'MFA'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name RADIUS authentication servers object to create.

    .PARAMETER IPAddress
        The IP address of the RADUIS server used to perform queries.

    .PARAMETER ServerName
        The FQDN of the RADIUS server used to perform queries.

    .PARAMETER Port
        Port number on which the RADIUS server listens for connections.

    .PARAMETER Timeout
        Number of seconds the NetScaler appliance waits for a response from the RADIUS server.

    .PARAMETER SharedSecret
        Key shared between the RADIUS server and the NetScaler appliance. 

    .PARAMETER NASIP
        If enabled, the NetScaler appliance IP address (NSIP) is sent to the RADIUS server as the Network Access Server IP (NASIP) address. 

        Possible values: ENABLED, DISABLED

    .PARAMETER NASID
        If configured, this string is sent to the RADIUS server as the Network Access Server ID.

    .PARAMETER VendorID
        RADIUS vendor ID attribute, used for RADIUS group extraction.

    .PARAMETER AttributeType
        RADIUS attribute type, used for RADIUS group extraction.

    .PARAMETER GroupsPrefix
        RADIUS groups prefix string. This groups prefix precedes the group names within a RADIUS attribute for RADIUS group extraction.

    .PARAMETER GroupSeparator
        RADIUS group separator string. The group separator delimits group names within a RADIUS attribute for RADIUS group extraction.

    .PARAMETER PasswordEncoding
        Encoding type for passwords in RADIUS packets that the NetScaler appliance sends to the RADIUS server.
        
        Default value: pap        
        Possible values = pap, chap, mschapv1, mschapv2

    .PARAMETER IPVendorID
        Vendor ID of the intranet IP attribute in the RADIUS response. A value of 0 indicates that the attribute is not vendor encoded.

    .PARAMETER IPAttributeType
        Remote IP address attribute type in a RADIUS response.

    .PARAMETER Accounting
        Whether the RADIUS server is currently accepting accounting messages.

        Possible values =  ON, OFF

    .PARAMETER PasswordVendorID
        Vendor ID of the attribute, in the RADIUS response, used to extract the user password.

    .PARAMETER PasswordAttributeType
        Vendor-specific password attribute type in a RADIUS response.

    .PARAMETER DefaultAuthenticationGroup
        This is the default group that is chosen when the authentication succeeds in addition to extracted groups.

    .PARAMETER CallingStationID
        Send Calling-Station-ID of the client to the RADIUS server. IP Address of the client is sent as its Calling-Station-ID.
        
        Default value: DISABLED
        Possible values = ENABLED, DISABLED

    .PARAMETER Retry
        Number of retry by the NetScaler appliance before getting response from the RADIUS server.
        
        Default value: 3
        Minimum value = 1
        Maximum value = 10

    .PARAMETER Authentication
        Configure the RADIUS server state to accept or refuse authentication messages.
        
        Default value: ON
        Possible values = ON, OFF
    
    .PARAMETER Passthru
        Return the LDAP authentication server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low', DefaultParameterSetName = 'IPAddress')]
    param (
        $Session = $Script:Session,

        [parameter(Mandatory)]
        [string] $Name,

        [parameter(ParameterSetName = 'IPAddress')]
        [string] $IPAddress,

        [parameter(ParameterSetName = 'FQDN')]
        [System.String] $ServerName,

        [int]$Port,

        [int]$Timeout,
        
        [string]$SharedSecret,

        [ValidateSet('ENABLED','DISABLED')]
        [string]$NASIP,

        [string]$NASID,

        [int]$VendorID,

        [int]$AttributeType,

        [string]$GroupsPrefix,

        [string]$GroupSeparator,

        [ValidateSet('PAP','CHAP','MSCHAPv1','MSCHAPv2')]
        [string]$PasswordEncoding,

        [int]$IPVendorID,

        [int]$IPAttributeType,

        [ValidateSet('ON','OFF')]
        [string]$Accounting,

        [int]$PasswordVendorID,

        [int]$PasswordAttributeType,

        [string]$DefaultAuthenticationGroup,
        
        [ValidateSet('ENABLED','DISABLED')]
        [string]$CallingStationID,

        [int]$Retry,

        [ValidateSet('ON','OFF')]
        [string]$Authentication,

        [switch] $PassThru
    )   
    
    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, "Add RADIUS Authentication Server")) {
            try {
                $propertyMap = @{
                    IPAddress                  = 'serverip'
                    ServerName                 = 'servername'
                    Port                       = 'serverport'
                    Timeout                    = 'authtimeout'
                    SharedSecret               = 'radkey'
                    NASIP                      = 'radnasip'
                    NASID                      = 'radnasid'
                    VendorID                   = 'radvendorid'
                    AttributeType              = 'radattributetype'
                    GroupsPrefix               = 'radgroupsprefix'
                    GroupSeparator             = 'radgroupseparator'
                    PasswordEncoding           = 'passencoding'
                    IPVendorID                 = 'ipvendorid'
                    IPAttributeType            = 'ipattributetype'
                    Accounting                 = 'accounting'
                    PasswordVendorID           = 'pwdvendorid'
                    PasswordAttributeType      = 'pwdattributetype'
                    DefaultAuthenticationGroup = 'defaultauthenticationgroup'
                    CallingStationID           = 'callingstationid'
                    Retry                      = 'authservretry'
                    Authentication             = 'authentication'
                }
                $params = @{
                    name = $Name
                }

                foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
                    if ($propertyMap.ContainsKey($parameter.Key)) {
                        $params[$propertyMap[$parameter.Key]] = $parameter.Value
                    }
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type authenticationradiusaction -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSRADIUSAuthenticationServer -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

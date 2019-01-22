<#
Copyright 2016 Iain Brighton

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

function New-NSLDAPAuthenticationServer {
    <#
    .SYNOPSIS
        Creates a new LDAP authentication server object.

    .DESCRIPTION
        Creates a new LDAP authentication server object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name LDAP authentication servers object to create.

    .PARAMETER IPAddress
        The IP address of the LDAP server used to perform queries.

    .PARAMETER ServerName
        The FQDN of the LDAP server used to perform queries.

    .PARAMETER Port
        Port on which the LDAP server accepts connections.

        Default value: 389

    .PARAMETER BaseDN
        Base (node) from which to start LDAP searches.

    .PARAMETER SecurityType
        Type of security used for communications between the NetScaler appliance and the LDAP server. For the PLAINTEXT setting, no encryption is required.

        Default value: PLAINTEXT
        Possible values: PLAINTEXT, TLS, SSL

    .PARAMETER ServerType
        The type of LDAP server.

        Possible values: AD, NDS

    .PARAMETER Credential
        LDAP login credential with the Full distinguished name (DN) that is used to bind to the LDAP server.
        The NetScaler appliance uses the login to query external LDAP servers or Active Directory.

    .PARAMETER LoginAttributeName
        LDAP login name attribute. The NetScaler appliance uses the LDAP login name to query external LDAP servers or Active Directories

    .PARAMETER SearchFilter
        String to be combined with the default LDAP user search string to form the search value.

    .PARAMETER GroupAttributeName
        LDAP group attribute name used for group extraction on the LDAP server.

    .PARAMETER SubAttributeName
        LDAP group sub-attribute name. Used for group extraction from the LDAP server.

    .PARAMETER SSOAttributeName
        LDAP single signon (SSO) attribute. The NetScaler appliance uses the SSO name attribute to query external LDAP servers or Active Directory for an alternate username.

    .PARAMETER NestedGroupExtraction
        Allow nested group extraction, in which the NetScaler appliance queries external LDAP servers to determine whether a group is part of another group.
        
        Default value: OFF
        Possible values = ON, OFF

    .PARAMETER MaxNestingLevel
        If nested group extraction is ON, specifies the number of levels up to which group extraction is performed.
        
        Default value: 2
        Minimum value = 2

    .PARAMETER GroupNameIdentifier
        If nested group extraction is ON, specifies the name that uniquely identifies a group in LDAP or Active Directory.
   
    .PARAMETER GroupSearchAttribute
        If nested group extraction is ON, specifies the LDAP group search attribute. Used to determine to which groups a group belongs.

    .PARAMETER GroupSearchSubattribute
        If nested group extraction is ON, specifies the LDAP group search subattribute. Used to determine to which groups a group belongs.

    .PARAMETER GroupSearchFilter
        If nested group extraction is ON, specifies the string to be combined with the default LDAP group search string to form the search value.

    .PARAMETER DefaultAuthenticationGroup
        If nested group extraction is ON, specifies the default group that is chosen when the authentication succeeds in addition to extracted groups.

    .PARAMETER Passthru
        Return the LDAP authentication server object.

    .EXAMPLE
        New-NSLDAPAuthenticationServer -Name ldap_DC1 -ServerName dc1.lab.local -BaseDN 'dc=lab,dc=local' -SecurityType PLAINTEXT -ServerType AD

        Creates a new LDAP authentication server to a server with the name 'dc1.lab.local' using plain LDAP

    .EXAMPLE
        New-NSLDAPAuthenticationServer -Name ldaps_DC1 -IPAddress 192.168.0.1 -BaseDN 'dc=lab,dc=local' -SecurityType SSL -Port 636 -ServerType AD -Credential (Get-Credential 'administrator@lab.local')

        Creates a new secure LDAP authentication server to a server with the IP address '192.168.0.1' using secure LDAP with the bind credentials supplied.
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

        [ValidateSet('PLAINTEXT','TLS','SSL')]
        [string] $SecurityType = 'PLAINTEXT',

        [ValidateSet('AD','NDS')]
        [string] $ServerType,

        [string] $BaseDN,

        [PSCredential] [System.Management.Automation.CredentialAttribute()] $Credential,

        [string] $LoginAttributeName,

        [string] $SearchFilter,

        [string] $GroupAttributeName,

        [string] $SubAttributeName,

        [string] $SSOAttributeName,

        [ValidateSet('ON', 'OFF')]
        [string] $NestedGroupExtraction,

        [int] $MaxNestingLevel,

        [string] $GroupNameIdentifier,

        [string] $GroupSearchAttribute,

        [string] $GroupSearchSubattribute,

        [string] $GroupSearchFilter,

        [string] $DefaultAuthenticationGroup,

        [switch] $PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, "Add LDAP Authentication Server")) {
            try {
                $params = @{
                    name = $Name
                }
                if ($PSBoundParameters.ContainsKey('IPAddress')) {
                    $params.Add('serverip', $IPAddress)
                }
                if ($PSBoundParameters.ContainsKey('ServerName')) {
                    $params.Add('servername', $ServerName)
                }
                if ($PSBoundParameters.ContainsKey('Port')) {
                    $params.Add('serverport', $Port)
                }
                if ($PSBoundParameters.ContainsKey('BaseDN')) {
                    $params.Add('ldapbase', $BaseDN)
                }
                if ($PSBoundParameters.ContainsKey('Credential')) {
                    $params.Add('ldapbinddn', $Credential.UserName)
                    $params.Add('ldapbinddnpassword', $Credential.GetNetworkCredential().Password)
                }
                if ($PSBoundParameters.ContainsKey('LoginAttributeName')) {
                    $params.Add('ldaploginname', $LoginAttributeName)
                }
                if ($PSBoundParameters.ContainsKey('SearchFilter')) {
                    $params.Add('searchfilter', $SearchFilter)
                }
                if ($PSBoundParameters.ContainsKey('GroupAttributeName')) {
                    $params.Add('groupattrname', $GroupAttributeName)
                }
                if ($PSBoundParameters.ContainsKey('SubAttributeName')) {
                    $params.Add('subattributename', $SubAttributeName)
                }
                if ($PSBoundParameters.ContainsKey('SecurityType')) {
                    $params.Add('sectype', $SecurityType)
                }
                if ($PSBoundParameters.ContainsKey('ServerType')) {
                    $params.Add('svrtype', $ServerType)
                }
                if ($PSBoundParameters.ContainsKey('SSOAttributeName')) {
                    $params.Add('ssonameattribute', $SSOAttributeName)
                }
                if ($PSBoundParameters.ContainsKey('NestedGroupExtraction')) {
                    $params.Add('nestedgroupextraction', $NestedGroupExtraction)
                }
                if ($PSBoundParameters.ContainsKey('MaxNestingLevel')) {
                    $params.Add('maxnestinglevel', $MaxNestingLevel)
                }
                if ($PSBoundParameters.ContainsKey('GroupNameIdentifier')) {
                    $params.Add('groupnameidentifier', $GroupNameIdentifier)
                }
                if ($PSBoundParameters.ContainsKey('GroupSearchAttribute')) {
                    $params.Add('groupsearchattribute', $GroupSearchAttribute)
                }
                if ($PSBoundParameters.ContainsKey('GroupSearchSubattribute')) {
                    $params.Add('groupsearchsubattribute', $GroupSearchSubattribute)
                }
                if ($PSBoundParameters.ContainsKey('GroupSearchFilter')) {
                    $params.Add('groupsearchfilter', $GroupSearchFilter)
                }
                if ($PSBoundParameters.ContainsKey('DefaultAuthenticationGroup')) {
                    $params.Add('defaultauthenticationgroup', $DefaultAuthenticationGroup)
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type authenticationldapaction -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSLDAPAuthenticationServer -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

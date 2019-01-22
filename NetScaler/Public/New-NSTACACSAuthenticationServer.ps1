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

function New-NSTACACSAuthenticationServer {
    <#
    .SYNOPSIS
        Creates a new TACACS+ authentication server object.

    .DESCRIPTION
        Creates a new TACACS+ authentication server object.

    .EXAMPLE
        New-NSTACACSAuthenticationServer -Name 'CISCO01' -IPAddress '192.168.0.254' -TACACSSecret 'abcd1234'

        Creates a new TACACS+ authentication server named 'CISCO01' with an IP address of '192.168.0.254' using the shared key 'abcd1234'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the TACACS+ profile (action).
        Must begin with a letter, number, or the underscore character (_), and must contain only letters, numbers, and the hyphen (-), period (.) pound (#), space ( ), at (@), equals (=), colon (:), and underscore characters. 

    .PARAMETER IPAddress
        IP address assigned to the TACACS+ server.
        Minimum length = 1

    .PARAMETER Timeout
        Number of seconds the NetScaler appliance waits for a response from the TACACS+ server.
        
        Default value: 3
        Minimum value = 1
    
    .PARAMETER Port
        Port number on which the TACACS+ server listens for connections.
        
        Default value: 49
        Minimum value = 1

    .PARAMETER TACACSSecret
        Key shared between the TACACS+ server and the NetScaler appliance. Required for allowing the NetScaler appliance to communicate with the TACACS+ server.
        
        Minimum length = 1

    .PARAMETER Authorization
        Use streaming authorization on the TACACS+ server.
        
        Possible values = ON, OFF

    .PARAMETER Accounting
        Whether the TACACS+ server is currently accepting accounting messages.
        
        Possible values = ON, OFF

    .PARAMETER Passthru
        Return the TACACS+ authentication server object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $Script:Session,

        [parameter(Mandatory)]
        [string] $Name,

        [parameter(Mandatory)]
        [string] $IPAddress,

        [int]$Timeout,

        [int]$Port,

        [string]$TACACSSecret,

        [ValidateSet('ON','OFF')]
        [string]$Authorization,
        
        [ValidateSet('ON','OFF')]
        [string]$Accounting,

        [switch] $PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($PSCmdlet.ShouldProcess($Name, "Add TACACS+ Authentication Server")) {
            try {
                $propertyMap = @{
                    IPAddress                  = 'serverip'
                    Port                       = 'serverport'
                    TACACSSecret               = 'tacacssecret'
                    Accounting                 = 'accounting'
                    Authorization              = 'authorization'
                    Timeout                    = 'authtimeout'
                }
                $params = @{
                    name = $Name
                }

                foreach ($parameter in $PSBoundParameters.GetEnumerator()) {
                    if ($propertyMap.ContainsKey($parameter.Key)) {
                        $params[$propertyMap[$parameter.Key]] = $parameter.Value
                    }
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type authenticationtacacsaction -Payload $params -Action add

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSTACACSAuthenticationServer -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

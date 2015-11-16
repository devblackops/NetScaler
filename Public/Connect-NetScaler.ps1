<#
Copyright 2015 Brandon Olin

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

function Connect-NetScaler {
    <#
    .SYNOPSIS
        Establish a session with Citrix NetScaler.

    .DESCRIPTION
        Establish a session with Citrix NetScaler.

    .EXAMPLE
        Connect-NetScaler -NSIP '10.10.10.10' -Credential (Get-Credential)

        Connect to the NetScaler with IP address 10.10.10.10 and prompt for credentials.

    .PARAMETER NSIP
        The IP or hostname of the NetScaler.

    .PARAMETER Credential
        The credential to authenticate to the NetScaler with.

    .PARAMETER Https
        Use HTTPs to connect to the NetScaler.

    .PARAMETER PassThru
        Return the NetScaler session object.
    #>
    [cmdletbinding()]
    param(
        [parameter(mandatory = $true)]
        [string]$NSIP = (Read-Host -Prompt 'NetScaler IP or hostname'),

        [parameter(mandatory = $true)]
        [pscredential]$Credential = (Get-Credential -Message 'NetScaler credential'),

        [switch]$Https,

        [switch]$PassThru
    )

    Write-Verbose -Message "Connecting to $NSIP..."

    try {
        if ($PSBoundParameters.ContainsKey('Https')) {
            $script:nitroSession = New-Object -TypeName com.citrix.netscaler.nitro.service.nitro_service -ArgumentList @($NSIP, 'https')
        } else {
            $script:nitroSession = New-Object -TypeName com.citrix.netscaler.nitro.service.nitro_service -ArgumentList @($NSIP, 'http')
        }
        $script:session = $script:nitroSession.Login($Credential.UserName, $Credential.GetNetworkCredential().Password)
        Write-Verbose -Message "Connecting to $NSIP successfully"

        if ($PSBoundParameters.ContainsKey('PassThru')) {
            return $script:nitroSession
        }
    } catch {
        throw $_
    }    
}
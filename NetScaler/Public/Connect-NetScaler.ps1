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

    .PARAMETER IPAddress
        The IP or hostname of the NetScaler.

    .PARAMETER Hostname
        The hostname or FQDN of the NetScaler.

    .PARAMETER Credential
        The credential to authenticate to the NetScaler with.

    .PARAMETER Timeout
        Timeout in seconds for session object.

    .PARAMETER Https
        Use HTTPs to connect to the NetScaler.

    .PARAMETER PassThru
        Return the NetScaler session object.
    #>
    [cmdletbinding(DefaultParameterSetName='Hostname')]
    param(
        [parameter(Mandatory, ParameterSetName='IP')]
        [ValidateScript({$_ -match [IPAddress]$_ })]
        [Alias('NSIP')]
        [string]$IPAddress,

        [parameter(Mandatory, ParameterSetName='Hostname')]
        [string]$Hostname,

        [parameter(Mandatory)]
        [pscredential]$Credential,

        [int]$Timeout = 900,

        [switch]$Https,

        [switch]$PassThru
    )

    if ($PSCmdlet.ParameterSetName -eq 'IP') {
        $endpoint = $IPAddress
    } else {
        $endpoint = $Hostname
    }

    if ($Https) {
        $scheme = 'https'
    } else {
        $scheme = 'http'
    }


    $session = New-Object -TypeName PSObject
    $session | Add-Member -NotePropertyName Endpoint -NotePropertyValue $endpoint -TypeName String
    $session | Add-Member -NotePropertyName Scheme   -NotePropertyValue $scheme -TypeName String
    $session | Add-Member -Name Uri -MemberType ScriptProperty -Value {
        "$($this.scheme)://$($this.endpoint)/nitro/v1"
    }
    $session | Add-Member -Name CreateUri -MemberType ScriptMethod -Value {
        Param(
            [String]$service,
            [String]$type
        )
        "$($this.Uri)/$service/$type"
    }

    Write-Verbose -Message "Connecting to $($session.Uri)..."

    try {
        $login = @{
            login = @{
                username = $Credential.UserName;
                password = $Credential.GetNetworkCredential().Password
                timeout = $Timeout
            }
        }
        $loginJson = ConvertTo-Json -InputObject $login

        $saveSession = @{}
        $params = @{
            Uri = "$($session.Uri)/config/login"
            Method = 'POST'
            Body = $loginJson
            SessionVariable = 'saveSession'
            ContentType = 'application/json'
        }
        $response = Invoke-RestMethod @params

        if ($response.severity -eq 'ERROR') {
            throw "Error. See response: `n$($response | Format-List -Property * | Out-String)"
        } else {
            Write-Verbose -Message "Response:`n$(ConvertTo-Json -InputObject $response | Out-String)"
        }
    } catch [Exception] {
        throw $_
    }

    $session | Add-Member -NotePropertyName WebSession -NotePropertyValue $saveSession -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $script:session = $session


    if ($PSBoundParameters.ContainsKey('PassThru')) {
        return $session
    }
}
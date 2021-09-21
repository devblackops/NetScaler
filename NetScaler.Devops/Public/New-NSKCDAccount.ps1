<#
Copyright 2016 Dominique Broeglin

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

function New-NSKCDAccount {
    <#
    .SYNOPSIS
        Creates a new KCD account.

    .DESCRIPTION
        Creates a new KCD account.

    .EXAMPLE
        $cred = Get-Credential
        New-NSKCDAccount -Name ns_svc -Realm LAB -DelegatedUser ns_svc -Credential $cred

        Create a new KCD account with the given delegated user.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the server.

        Must begin with an ASCII alphabetic or underscore (_) character, and must contain only
        ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=),
        and hyphen (-) characters. Can be changed after the name is created.

        Minimum length = 1

    .PARAMETER Realm
        Kerberos realm the delegation occurs in.

    .PARAMETER Credential
        Credential holding delegated username and password.

    .PARAMETER Passthru
        Return the load balancer server object.

    .NOTES
        Nitro implementation status: partial

    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true)]
        [String[]]$Name,

        [parameter(Mandatory = $true)]
        [String]$Realm,

        [parameter(Mandatory = $true)]
        [pscredential]$Credential,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($PSCmdlet.ShouldProcess($item, 'Create KCD account')) {
                try {
                    $params = @{
                        kcdaccount    = $item
                        realmstr      = $Realm
                        delegateduser = $Credential.Username
                        kcdpassword   = $Credential.GetNetworkCredential().password
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type aaakcdaccount -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return (Get-KCDAccount -Session $session -Name $item)
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
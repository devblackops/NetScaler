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
        New-KCDAccount -Name ns_svc -Realm LAB -DelegatedUser ns_svc -DelegatedUserPassword blabla
        
        Create a new KCD account with the given delegated user.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the server. 
    
        Must begin with an ASCII alphabetic or underscore (_) character, and must contain only 
        ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), 
        and hyphen (-) characters. Can be changed after the name is created.
        
        Minimum length = 1

    .PARAMETER DelegatedUser
        Username of the delegated user. The user Netscaler uses to get delegated tickets.

    .PARAMETER DelegatedUserPassword
        Password of the delegated user.

    .PARAMETER Realm
        Kerberos realm the delegation occurs in.

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

        [String]$Realm,

        [String]$DelegatedUser,

        [String]$DelegatedUserPassword,

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
                        delegateduser = $DelegatedUser
                        kcdpassword   = $DelegatedUserPassword
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
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

function Remove-NSVPNSessionPolicy {
    <#
    .SYNOPSIS
        Delete an existing NetScaler Gateway session policy resource.

    .DESCRIPTION
        Delete an existing NetScaler Gateway session policy resource.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the NetScaler Gateway session policy to remove.

        Minimum length = 1

    .PARAMETER Force
        Suppress confirmation when creating the NetScaler Gateway session profile.

    .EXAMPLE
        Remove-NSVPNSessionPolicy -Session $Session -Name 'POL_OS_10.108.151.1_S'

        Deletes the NetScaler Gateway sesison policy named 'POL_OS_10.108.151.1_S'
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param (
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($Name, 'Delete NetScaler Gateway Session Policy')) {
            try {
                _InvokeNSRestApi -Session $Session -Method Delete -Type vpnsessionpolicy -Resource $Name
            } catch {
                throw $_
            }
        }
    }
}

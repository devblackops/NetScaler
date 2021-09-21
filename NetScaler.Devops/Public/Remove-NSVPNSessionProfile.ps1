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

function Remove-NSVPNSessionProfile {
    <#
    .SYNOPSIS
        Delete an existing NetScaler Gateway session profile resource.

    .DESCRIPTION
        Delete an existing NetScaler Gateway session profile resource.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name of the NetScaler Gateway session profile (action) to remove.

        Minimum length = 1

    .PARAMETER Force
        Suppress confirmation when creating the NetScaler Gateway session profile.

    .EXAMPLE
        Remove-NSVPNSessionProfile -Session $Session -Name 'prof_receiver'

        Deletes the NetScaler Gateway session profile named 'prof_receiver'.
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
        if ($Force -or $PSCmdlet.ShouldProcess($Name, 'Delete NetScaler Gateway Session Profile')) {
            try {
                _InvokeNSRestApi -Session $Session -Method Delete -Type vpnsessionaction -Resource $Name
            }
            catch {
                throw $_
            }
        }
    }
}

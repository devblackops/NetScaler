<#
Copyright 2017 Juan C. Herrera

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

function Remove-NSResponderPolicy {
    <#
    .SYNOPSIS
        Removes a responder policy.

    .DESCRIPTION
        Removes a responder policy.

    .EXAMPLE
        Remove-NSResponderPolicy -Name 'act-redirect'

        Removes a responder policy which uses the 'Redirect act' responder action

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of responder policy.

    .PARAMETER Force
        Suppress confirmation when removing a responder action.        
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Responder Policy')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type responderpolicy -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
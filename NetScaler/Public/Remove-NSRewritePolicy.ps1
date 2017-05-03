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

function Remove-NSRewritePolicy {
    <#
    .SYNOPSIS
        Removes a rewrite policy.

    .DESCRIPTION
        Removes a rewrite policy.

    .EXAMPLE
        Remove-NSRewritePolicy -Name 'act-redirect'

        Removes a rewrite policy which uses the 'Redirect act' rewrite action

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of rewrite policy.

    .PARAMETER Force
        Suppress confirmation when removing a rewrite action.        
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
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Rewrite Policy')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type rewritepolicy -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
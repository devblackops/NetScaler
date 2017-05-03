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

function Remove-NSRewriteAction {
    <#
    .SYNOPSIS
        Removes a rewrite action.

    .DESCRIPTION
        Removes a rewrite action.

    .EXAMPLE
        Remove-NSRewriteAction -Name 'act-redirect'

        Removes the rewrite action named 'act-redirect'.

    .EXAMPLE
        'act-1', 'act-2' | Remove-NSRewriteAction
    
        Removes the rewrite action named 'act-1' and 'act-2'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the rewrite actions to remove.

    .PARAMETER Force
        Suppress confirmation when removing a rewrite action.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [switch]$Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete Rewrite Action')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type rewriteaction -Resource $item -Action delete
                } catch {
                    throw $_
                }
            }
        }
    }
}
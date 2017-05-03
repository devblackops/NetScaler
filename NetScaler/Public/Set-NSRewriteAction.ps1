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

function Set-NSRewriteAction {
    <#
    .SYNOPSIS
        Updates a rewrite action.

    .DESCRIPTION
        Updates a rewrite action.

    .EXAMPLE
        Set-NSRewriteAction -Name 'act-rewrite' -Type Replace `
            -Target 'HTTP.REQ.HOSTNAME' -Expression '"www.lab.local"'

        Updates a rewrite action which rewrites the 'Host' header with the value 'www.lab.local'

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of rewrite action.

    .PARAMETER Type
        The type of rewrite action to create.
        
        Possible values = Replace

    .PARAMETER Target
        The target expression for the rewrite action.

        Minimum length: 0
        Maximum length: 8191

    .PARAMETER Expression
        The expression value used by the rewrite target. Its exact meaning depends on the type.

        Minimum length: 0
        Maximum length: 8191
        
    .PARAMETER Comment
        Any information about the rewrite action.

        Minimum length: 0
        Maximum length: 256

    .PARAMETER Passthru
        Return the rewrite action.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [Parameter(Mandatory)]
        [ValidateSet('Replace')] 
        [string]$Type,

        [Parameter(Mandatory)]
        [ValidateLength(0, 8191)]
        [string]$Target,

        [Parameter(Mandatory)]
        [ValidateLength(0, 8191)]
        [string]$Expression,

        [ValidateLength(0, 256)]
        [string]$Comment = [string]::Empty,
        
        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($Item in $Name) {
            if ($PSCmdlet.ShouldProcess($Item, 'Create rewrite action')) {
                try {
                    $params = @{
                        name                = $Item
                        type                = $Type.ToLower()
                        comment             = $Comment
                        target              = $Target
                        stringbuilderexpr   = $Expression
                    }
                    _InvokeNSRestApi -Session $Session -Method PUT -Type rewriteaction -Payload $params -Action update

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSRewriteAction -Session $Session -Name $Item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
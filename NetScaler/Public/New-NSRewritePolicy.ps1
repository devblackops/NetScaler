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

function New-NSRewritePolicy {
    <#
    .SYNOPSIS
        Adds a rewrite porlicy.

    .DESCRIPTION
        Adds a rewrite policy.

    .EXAMPLE
        New-NSRewritePolicy -Name 'pol-rewrite' -ActionName 'act-rewrite' -Expression 'true'

        Creates a new rewrite policy which always applies the 'act-rewrite' action.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of rewrite policy.

    .PARAMETER ActionName
        The name of the action to execute when this policy is matched.

    .PARAMETER LogActionName
        The name of the log action to execute when this policy is matched.
        
        Default value: ""
        
    .PARAMETER Rule
        The rule/expression that has to be matched for this policy to apply.

        Minimum length: 0
        Maximum length: 8191
        Alias: Expression

    .PARAMETER Expression
        The rule/expression that has to be matched for this policy to apply.

        Minimum length: 0
        Maximum length: 8191
        Alias for: Rule
                
    .PARAMETER Comment
        Any information about the rewrite policy.

        Minimum length: 0
        Maximum length: 256

    .PARAMETER Passthru
        Return the newly created rewrite policy.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [Parameter(Mandatory)]
        [string]$ActionName,

        [string]$LogActionName = "",

        [Parameter(Mandatory)]
        [ValidateLength(0, 8191)]
        [Alias('Expression')]
        [string]$Rule,

        [ValidateLength(0, 256)]
        [string]$Comment = "",
        
        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($Item in $Name) {
            if ($PSCmdlet.ShouldProcess($Item, 'Create rewrite policy')) {
                try {
                    $params = @{
                        name = $Item
                        action = $ActionName
                        comment = $Comment
                        logaction = $LogActionName
                        rule = $Rule
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type rewritepolicy -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSRewritePolicy -Session $Session -Name $Item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
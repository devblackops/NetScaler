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

function Set-NSResponderAction {
    <#
    .SYNOPSIS
        Updates an existing responder action.

    .DESCRIPTION
        Updates an existing responder action.

    .EXAMPLE
        Set-NSResponderAction -Name 'act-redirect' -Target '"/test"'

        Sets the target (expression) for responder action 'act-redirect' to /test.

    .EXAMPLE
        Set-NSResponderAction -Name 'act-redirect' -Comment 'this is a comment' -PassThru

        Sets the comment for responder action 'act-redirect' and returns the updated object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the responder actions to set.

    .PARAMETER Target
        The target expression for the responder action.
        Valid only for types NOOP, Redirect and RespondWith.

    .PARAMETER ResponseStatusCode
        The HTTP response status code returned by the responder action.
        Valid only for types Redirect, RespondWith, RespondWithSQLOK and RespondWithSQLError.

        Range: 100 - 599

    .PARAMETER ReasonPhrase
        The Reason Phrase returned with the HTTP status code.
        Valid only for types Redirect, RespondWith, RespondWithSQLOK and RespondWithSQLError.

        Minimum length: 0
        Maximum length: 8191

    .PARAMETER HtmlPage
        The name of the HTML page to respond with.

        Valid only for type RespondWithHTMLPage.

    .PARAMETER Comment
        The comment associated with the responder action.

    .PARAMETER Force
        Suppress confirmation when updating a responder action.

    .PARAMETER Passthru
        Return the responder action object.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Medium')]
    param(
        $Session = $script:session,

        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [ValidateLength(0, 8191)]
        [Alias('Expression')]
        [string]$Target = [string]::Empty,

        [ValidateRange(100, 599)]
        [int]$ResponseStatusCode,

        [ValidateLength(0, 8191)]
        [string]$ReasonPhrase = [string]::Empty,

        [ValidateLength(0, 256)]
        [string]$Comment = [string]::Empty,

        [ValidateLength(0, 256)]
        [string]$HtmlPage = [string]::Empty,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Edit Responder Action')) {
                $params = @{
                    name = $Name
                }
                if ($PSBoundParameters.ContainsKey('Target')) {
                    $params.Add('target', $Target)
                }
                if ($PSBoundParameters.ContainsKey('ResponseStatusCode')) {
                    $params.Add('responsestatuscode', $ResponseStatusCode)
                }
                if ($PSBoundParameters.ContainsKey('ReasonPhrase')) {
                    $params.Add('reasonphrase', $ReasonPhrase)
                }
                if ($PSBoundParameters.ContainsKey('HtmlPage')) {
                    $params.Add('htmlpage', $HtmlPage)
                }
                if ($PSBoundParameters.ContainsKey('Comment')) {
                    $params.Add('comment', $Comment)
                }
                _InvokeNSRestApi -Session $Session -Method PUT -Type responderaction -Payload $params -Action update

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSResponderAction -Session $Session -Name $item
                }
            }
        }
    }
}
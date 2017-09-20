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

function New-NSResponderAction {
    <#
    .SYNOPSIS
        Adds a responder action.

    .DESCRIPTION
        Adds a responder action.

    .EXAMPLE
        New-NSResponderAction -Name 'act-redirect' -Type Redirect -Target '"https://" + HTTP.REQ.HOSTNAME.HTTP_URL_SAFE + "/test/"' -ResponseStatusCode 302

        Creates a new responder action which redirects to /test

        New-NSResponderAction -Name NewHTMLPage -Type RespondWithHTMLPage -HTMLPage "NewHTMLPage"
        Creates a new responder action that uses a html page. Html pages are uploaded via the New-NSResponderHTMLPage function. The HTML page used in this example is just a label


    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of responder action.

    .PARAMETER Type
        The type of responder action to create.

        Default value: NOOP
        Possible values = NOOP, Redirect, RespondWith, RespondWithSQLOK, RespondWithSQLError, RespondWithHTMLPage

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
        Any information about the responder action.

        Minimum length: 0
        Maximum length: 256

    .PARAMETER Passthru
        Return the newly created responder action.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [ValidateSet('NOOP','Redirect','RespondWith', 'RespondWithSQLOK','RespondWithSQLError','RespondWithHTMLPage')]
        [string]$Type = 'NOOP',

        [ValidateLength(0, 8191)]
        [Alias('Expression')]
        [string]$Target = [string]::Empty,

        [ValidateRange(100, 599)]
        [int]$ResponseStatusCode,

        [ValidateLength(0, 8191)]
        [string]$ReasonPhrase = [string]::Empty,

        [ValidateLength(0, 8191)]
        [string]$HTMLPage = [string]::Empty,

        [ValidateLength(0, 256)]
        [string]$Comment = [string]::Empty,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($Item in $Name) {
            if ($PSCmdlet.ShouldProcess($Item, 'Create responder action')) {
                try {
                    $NitroType = $(
                        switch ($Type) {
                            "RespondWithSQLOK" { "sqlresponse_ok" }
                            "RespondWithSQLError" { "sqlresponse_error" }
                            "RespondWithHTMLPage" { "respondwithhtmlpage"}
                            default { $Type.ToLower() }
                        }
                    )

                    $params = @{
                        name        = $Item
                        type        = $NitroType
                        comment     = $Comment
                    }
                    switch -regex ($Type) {
                        "^(noop|redirect|respondwith)$" {
                            if ($PSBoundParameters.ContainsKey('Target')) {
                                $params.Add('target', $Target)
                            } else {
                                throw "Target is mandatory if type is NOOP, Redirect or RespondWith"
                            }
                        }
                        "^(redirect|sqlresponse_ok|sqlresponse_error|respondwithhtmlpage)$" {
                            if ($PSBoundParameters.ContainsKey('ResponseStatusCode')) {
                                $params.Add('responsestatuscode', $ResponseStatusCode)
                            }
                            if ($PSBoundParameters.ContainsKey('ReasonPhrase')) {
                                $params.Add('reasonphrase', $ReasonPhrase)
                            }
                        }
                        "respondwithhtmlpage" {
                            if ($PSBoundParameters.ContainsKey('HtmlPage')) {
                                $params.Add('htmlpage', $HtmlPage)
                            }
                        }
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type responderaction -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSResponderAction -Session $Session -Name $Item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
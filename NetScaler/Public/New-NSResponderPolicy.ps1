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

function New-NSResponderPolicy {
    <#
    .SYNOPSIS
        Adds a responder policy.

    .DESCRIPTION
        Adds a responder policy.

    .EXAMPLE
        New-NSResponderPolicy -Name 'act-redirect' -Rule 'HTTP.REQ.URL.EQ("/")' -Action 'Redirect act'

        Creates a new responder policy which uses the 'Redirect act' responder action

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of responder policy.

    .PARAMETER Rule
        Default syntax expression that the policy uses to determine whether to respond to the specified request.

    .PARAMETER Action
        Name of the responder action to perform if the request matches this responder policy. There are also some built-in actions which can be used. These are:
        * NOOP - Send the request to the protected server instead of responding to it.
        * RESET - Reset the client connection by closing it. The client program, such as a browser, will handle this and may inform the user. The client may then resend the request if desired.
        * DROP - Drop the request without sending a response to the user.

    .PARAMETER UndefinedAction
        Action to perform if the result of policy evaluation is undefined (UNDEF). An UNDEF event indicates an internal error condition. Only the above built-in actions can be used

    .PARAMETER Comment
        Adds a comment to the Responder Policy.

    .PARAMETER Passthru
        Return the newly created responder policy.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,

        [Parameter(Mandatory=$True)]
        [string]$Rule,

        [Parameter(Mandatory=$True)]
        [string]$Action,

        [Parameter()]
        [ValidateSet('NOOP','RESET','DROP')]
        [string]$UndefinedAction = '',

        [Parameter()]
        [string]$Comment,

        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($Item in $Name) {
            if ($PSCmdlet.ShouldProcess($Item, 'Create Responder Policy')) {
                try {
                    $params = @{
                        name = $Item
                        rule = $Rule
                        action = $Action
                        comment = $Comment
                        undefaction = $UndefinedAction
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type responderpolicy -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSResponderPolicy -Session $session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
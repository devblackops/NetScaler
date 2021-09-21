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

function New-NSVPNSessionPolicy {
    <#
    .SYNOPSIS
        Create NetScaler Gateway session policy resource.

    .DESCRIPTION
        Create NetScaler Gateway session policy resource.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the NetScaler Gateway profile (action). Must begin with an ASCII alphabetic or underscore (_) character, and must consist only of ASCII alphanumeric, underscore, hash (#), period (.), space, colon (:), at (@), equals (=), and hyphen (-) characters. Cannot be changed after the profile is created. The following requirement applies only to the NetScaler CLI: If the name includes one or more spaces, enclose the name in double or single quotation marks (for example, "my action" or 'my action').

        Minimum length = 1

    .PARAMETER SessionProfileName
        Session profile (Action) to be applied by the new session policy if the rule criteria are met.

        Minimum length = 1

    .PARAMETER Rule
        Expression, or name of a named expression, specifying the traffic that matches the policy. Can be written in either default or classic syntax. Maximum length of a string literal in the expression is 255 characters. A longer string can be split into smaller strings of up to 255 characters each, and the smaller strings concatenated with the + operator. For example, you can create a 500-character string as follows: '"<string of 255 characters>" + "<string of 245 characters>"' The following requirements apply only to the NetScaler CLI: * If the expression includes one or more spaces, enclose the entire expression in double quotation marks. * If the expression itself includes double quotation marks, escape the quotations by using the \ character. * Alternatively, you can use single quotation marks to enclose the rule, in which case you do not have to escape the double quotation marks.

    .PARAMETER Passthru
        Return the NetScaler Gateway session profile object.

    .PARAMETER Force
        Suppress confirmation when creating the NetScaler Gateway session profile.

    .EXAMPLE
        New-NSVPNSessionPolicy -Session $Session -Name "prof_receiver" -SessionProfileName "session_receiver" -Rule "REQ.HTTP.HEADER User-Agent CONTAINS CitrixReceiver"

        Creates a new NetScaler Gateway session policy named 'prof_receiver'.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param (
        $Session = $script:session,

        [parameter(Mandatory)]
        [string]$Name,

        [parameter(Mandatory)]
        [alias('ProfileName')]
        [string]$SessionProfileName,

        [parameter(Mandatory)]
        [string]$Rule,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($Name, 'Add NetScaler Gateway Session Policy')) {
            try {
                $params = @{
                    name = $Name
                    action = $SessionProfileName
                    rule = $Rule
                }

                _InvokeNSRestApi -Session $Session -Method POST -Type vpnsessionpolicy -Payload $params

                if ($PSBoundParameters.ContainsKey('PassThru')) {
                    return Get-NSVPNSessionPolicy -Session $Session -Name $Name
                }
            }
            catch {
                throw $_
            }
        }
    }
}

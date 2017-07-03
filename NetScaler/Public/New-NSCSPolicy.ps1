<#
Copyright 2017 Eric Carr

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

function New-NSCSPolicy {
    <#
    .SYNOPSIS
        Adds a content switching policy.

    .DESCRIPTION
        Adds a content switching policy.

    .EXAMPLE
        New-NSCSPolicy -Name 'policy-CS' -Rule 'CLIENT.IP.SRC.SUBNET(24).EQ(10.217.84.0)'

        Creates a new content switching policy using the rule provided

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of content switching policy.

    .PARAMETER Domain
        The domain to match against for this policy.

    .PARAMETER URL
        The URL or part of URL that is matched for the policy.

    .PARAMETER Rule
        The rule/expression that has to be matched for this policy to apply.

        Minimum length: 0
        Maximum length: 8191

    .PARAMETER Action
        The name of the action to execute when this policy is matched.

    .PARAMETER Passthru
        Return the newly created rewrite policy.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:session,

        [Parameter(Mandatory, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name,
        
        [Parameter(Mandatory = $true, ParameterSetName = "Domain")]
        [string]$Domain,
        
        [Parameter(Mandatory = $true, ParameterSetName = "URL")]
        [string]$URL,
        
        [Parameter(Mandatory = $true, ParameterSetName = "Rule")]
        [ValidateLength(0, 8191)]
        [string]$Rule,
        
        [Parameter(ParameterSetName = "Rule")]
        [string]$Action,
        
        [Switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($Item in $Name) {
            if ($PSCmdlet.ShouldProcess($Item, 'Create content switching policy')) {
                try {
                    if ($Domain) {
                        $params = @{
                            policyname = $Item
                            domain = $Domain
                        }
                    } elseif ($URL) {
                        $params = @{
                            policyname = $Item
                            url = $URL
                        }
                    } elseif ($Action) {
                        $params = @{
                            policyname = $Item
                            rule = $Rule
                            action = $Action
                        }
                    } else {
                        $params = @{
                            policyname = $Item
                            rule = $Rule
                        }
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type cspolicy -Payload $params -Action add

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSCSPolicy -Session $Session -Name $Item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
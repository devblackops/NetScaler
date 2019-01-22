<#
Copyright 2019 Iain Brighton

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

function Remove-NSSAMLAuthenticationPolicy {
    <#
    .SYNOPSIS
        Removes an existing SAML authentication policy.

    .DESCRIPTION
        Removes an existing SAML authentication policy.

    .EXAMPLE
        Remove-NSSAMLAuthenticationPolicy -Name 'policy_saml_sso'

        Removes the SAML authentication policy named 'policy_saml_sso'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name of the SAML authentication policy to remove.

    .PARAMETER Force
        Suppress confirmation when removing a SAML authentication policy.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
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
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Delete SAML Authentication Policy')) {
                try {
                    _InvokeNSRestApi -Session $Session -Method DELETE -Type authenticationsamlpolicy -Resource $item -Action delete
                }
                catch {
                    throw $_
                }
            }
        }
    }
}

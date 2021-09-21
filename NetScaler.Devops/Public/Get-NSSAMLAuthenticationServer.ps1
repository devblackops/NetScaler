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

function Get-NSSAMLAuthenticationServer {
    <#
    .SYNOPSIS
        Gets the specified SAML authentication server object(s).

    .DESCRIPTION
        Gets the specified SAML authentication server object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSSAMLAuthenticationServer

        Get all SAML authentication server objects.

    .EXAMPLE
        Get-NSSAMLAuthenticationServer -Name 'foobar'
    
        Get the SAML authentication server named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the SAML authentication servers to get.

    .PARAMETER RedirectUrl
        A filter to apply to the SAML redirect URL value.

    .PARAMETER ServerName
        A filter to apply to the SAML authentication server name value.

    .PARAMETER IDPCertificateName
        A filter to apply to the SAML IDP certificate name value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$RedirectUrl,

        [Parameter(ParameterSetName='search')]

        [string]$ServerName,

        [Parameter(ParameterSetName='search')]

        [string]$IDPCertificateName
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('RedirectUrl')) {
            $Filters['samlredirecturl'] = $RedirectUrl
        }
        if ($PSBoundParameters.ContainsKey('ServerName')) {
            $Filters['name'] = $ServerName
        }
        if ($PSBoundParameters.ContainsKey('IDPCertificateName')) {
            $Filters['samlidpcertname'] = $IDPCertificateName
        }
        _InvokeNSRestApiGet -Session $Session -Type authenticationsamlaction -Name $Name -Filters $Filters
    }
}

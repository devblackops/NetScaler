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

function Get-NSSSLCertificate {
    <#
    .SYNOPSIS
        Gets the specified SSL certificate object(s).

    .DESCRIPTION
        Gets the specified SSL certificate object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSSSLCertificate

        Get all SSL certificate objects.

    .EXAMPLE
        Get-NSSSLCertificate -Name 'foobar'
    
        Get the SSL certificate named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the SSL certificates to get.

    .PARAMETER CertificateName
        A filter to apply to the certificate name value.

    .PARAMETER DayToExpiration
        A filter to apply to the days to expiration value.

    .PARAMETER Status
        A filter to apply to the status value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]

        [string]$CertificateName,

        [Parameter(ParameterSetName='search')]

        [string]$DayToExpiration,

        [Parameter(ParameterSetName='search')]

        [string]$Status
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{}
        if ($PSBoundParameters.ContainsKey('CertificateName')) {
            $Filters['certkey'] = $CertificateName
        }
        if ($PSBoundParameters.ContainsKey('DayToExpiration')) {
            $Filters['daystoexpiration'] = $DayToExpiration
        }
        if ($PSBoundParameters.ContainsKey('Status')) {
            $Filters['status'] = $Status
        }
        _InvokeNSRestApiGet -Session $Session -Type sslcertkey -Name $Name -Filters $Filters
    }
}

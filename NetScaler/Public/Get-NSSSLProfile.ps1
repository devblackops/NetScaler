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

function Get-NSSSLProfile {
    <#
    .SYNOPSIS
        Gets the specified SSL profile object.

    .DESCRIPTION
        Gets the specified SSL profile object.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the SSL profiles to get.

    .EXAMPLE
        Get-NSSSLProfile

        Get all SSL profile objects.

    .EXAMPLE
        Get-NSSSLProfile -Name 'ns_default_ssl_profile_frontend'

        Get the SSL profile named 'ns_default_ssl_profile_frontend'.
    #>
    [cmdletbinding()]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0)]
        [string[]]$Name = @()
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            _InvokeNSRestApiGet -Session $Session -Type sslprofile -Name $Name
        }
        catch {
            throw $_
        }
    }
}

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

function Get-NSVersion {
    <#
    .SYNOPSIS
        Gets the version information for the NetScaler appliance.

    .DESCRIPTION
        Gets the version information for the NetScaler appliance.

    .EXAMPLE
        Get-NSVersion

        Get the NetScaler version information.

    .PARAMETER Session
        The NetScaler session object.

    #>
    [cmdletbinding()]
    param(
        $Session = $script:session
    )

    begin {
        _AssertSessionActive
    }

    process {
        try {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type nsversion
            if ($response.nsversion.version -match 'NetScaler NS\d+\.\d+:\s?Build\s\d+.\d+') {
                if ($response.nsversion.version -match '(?<=^NetScaler NS)\d+\.\d+(?=:)') {
                    $versionString = $Matches[0]
                    $major = $versionString.Split('.')[0]
                    $minor = $versionString.Split('.')[1]
                }
                if ($response.nsversion.version -match '(?<=Build\s)\S+(?=\,)') {
                    $buildString = $Matches[0]
                }
                return [PSCustomObject] @{
                    DisplayName = $response.nsversion.version.Split(',')[0]
                    Version = New-Object System.Version -ArgumentList @($major, $minor)
                    Build = $buildString
                    KernelMode = $response.nsversion.mode -as [System.Int32]
                }
            }
        }
        catch {
            throw $_
        }
    }
}

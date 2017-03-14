<#
Copyright 2015 Brandon Olin

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

function Disable-NSFeature {
    <#
    .SYNOPSIS
        Disable feature on NetScaler appliance.

    .DESCRIPTION
        Disable feature on NetScaler appliance.

    .EXAMPLE
        Disable-NSFeature -Name 'lb'

        Disable the feature 'lb' on the NetScaler appliance.

    .EXAMPLE
        'sslvpn', 'lb' | Disable-NSFeature -Force
    
        Disable the features 'sslvpn' and 'lb' on the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the NetScaler features to disable.

    .PARAMETER Force
        Suppress confirmation when disabling the feature.

    .PARAMETER PassThru
        Return the status of the NetScaler features.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory, ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name,

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            $item = $item.ToLower()
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Disable NetScaler feature')) {
                try {
                    $params = @{
                        feature = $item
                    }
                    _InvokeNSRestApi -Session $Session -Method POST -Type nsfeature -Payload $params -Action disable

                    if ($PSBoundParameters.ContainsKey('PassThru')) {
                        return Get-NSFeature -Session $Session -Name $item
                    }
                } catch {
                    throw $_
                }
            }
        }
    }
}
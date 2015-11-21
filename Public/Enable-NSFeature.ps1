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

function Enable-NSFeature {
    <#
    .SYNOPSIS
        Enable feature on NetScaler appliance.

    .DESCRIPTION
        Enable feature on NetScaler appliance.

    .EXAMPLE
        Enable-NSFeature -Name 'lb'

        Enable the feature 'lb' on the NetScaler appliance.

    .EXAMPLE
        'sslvpn', 'lb' | Enable-NSFeature -Force
    
        Enable the features 'sslvpn' and 'lb' on the NetScaler appliance.    

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the NetScaler features to enable.

    .PARAMETER Force
        Suppress confirmation when enabling the feature.

    .PARAMETER PassThru
        Return the status of the NetScaler features.
    #>
    [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        $Session = $script:session,

        [parameter(Mandatory,ValueFromPipeline = $true, ValueFromPipelineByPropertyName)]
        [string[]]$Name = (Read-Host -Prompt 'NetScaler feature'),

        [switch]$Force,

        [switch]$PassThru
    )

    begin {
        _AssertSessionActive
    }

    process {
        foreach ($item in $Name) {
            $item = $item.ToLower()
            if ($Force -or $PSCmdlet.ShouldProcess($item, 'Enable NetScaler feature')) {
                try {
                    $params = @{
                        feature = $item
                    }
                    $response = _InvokeNSRestApi -Session $Session -Method POST -Type nsfeature -Payload $params -Action enable
                    if ($response.errorcode -ne 0) { throw $response }

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
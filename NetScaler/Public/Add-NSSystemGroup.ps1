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

function Add-NSSystemGroup {
    <#
    .SYNOPSIS
        Add a system group to the NetScaler appliance.

    .DESCRIPTION
        Add a system group to the NetScaler appliance.

    .EXAMPLE
        Add-NSSystemGroup -Name 'G-NetScalerAdmins'

        Adds the local 'G-NetScalerAdmins' group to the NetScaler appliance.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name for the group.

    .PARAMETER PromptString
        String to display at the command-line prompt. 

    .PARAMETER Timeout
        CLI session inactivity timeout, in seconds. If Restrictedtimeout argument of system parameter is enabled, Timeout can have values in the range [300-86400] seconds.
        If Restrictedtimeout argument of system parameter is disabled, Timeout can have values in the range [0, 10-100000000] seconds.
        
        Default value is 900 seconds.

    .PARAMETER Force
        Suppress confirmation when creating the system group.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
    param(
        $Session = $script:Session,

        [parameter(Mandatory)]
        [alias('GroupName')]
        [string] $Name,

        [string] $PromptString,

        [int] $Timeout,

        [switch] $Force
    )

    begin {
        _AssertSessionActive
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess($Name, 'Add system group')) {
            try {
                $params = @{
                    groupname = $Name
                }
                if ($PSBoundParameters.ContainsKey('PromptString')) {
                    $params['PromptString'] = $PromptString
                }
                if ($PSBoundParameters.ContainsKey('Timeout')) {
                    $params['Timeout'] = $Timeout
                }
                
                _InvokeNSRestApi -Session $Session -Method POST -Type systemgroup -Payload $params -Action add
            }
            catch {
                throw $_
            }
        }
    }
}

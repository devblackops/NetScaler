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

function Get-NSSystemGroup {
    <#
    .SYNOPSIS
        Gets a system group object.

    .DESCRIPTION
        Gets a system group object.

    .EXAMPLE
        Get-NSSystemGroup -Name 'G-NetScalerAdmins'

        Returns the local 'G-NetScalerAdmins' system group.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        Name(s) of the system group to return.
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
            _InvokeNSRestApiGet -Session $Session -Type systemgroup -Name $Name
        }
        catch {
            throw $_
        }
    }
}

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

function Get-NSLBStat {
    [cmdletbinding()]
    param(
        $Session = $script:nitroSession,

        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = (Read-Host -Prompt 'LB stat name')
    )

    begin {
        _AssertSessionActive
        $stats = @()
    }

    process {
        if ($Name.Count -gt 0) {
            foreach ($item in $Name) {
                $stats = [com.citrix.netscaler.nitro.resource.stat.lb.lbvserver_stats]::get($session, $item)
                $stats
            }
        } else {
            $stats = [com.citrix.netscaler.nitro.resource.stat.lb.lbvserver_stats]::get($session)
            $stats
        }
    }
}
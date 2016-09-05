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

function Invoke-Nitro {
    <#
    .SYNOPSIS
        Invoke NetScaler NITRO REST API
    .DESCRIPTION
        Invoke NetScaler NITRO REST API
    .PARAMETER Session
        An existing custom NetScaler Web Request Session object returned by Connect-NetScaler
    .PARAMETER Method
        Specifies the method used for the web request
    .PARAMETER Type
        Type of the NS appliance resource
    .PARAMETER Resource
        Name of the NS appliance resource, optional
    .PARAMETER Action
        Name of the action to perform on the NS appliance resource
    .PARAMETER Arguments
        Hashtable of arguments to send when invoking NetScaler API directly.
    .PARAMETER Stat
        Switch indicating API will operate in the 'Stat` namespace instead of the 'Config' namespace.
    .PARAMETER Filters
        Hashtable of filters to apply when invoking a GET request against the NetScaler API.
    .PARAMETER Payload
        Payload  of the web request, in hashtable format
    .PARAMETER GetWarning
        Switch parameter, when turned on, warning message will be sent in 'message' field and 'WARNING' value is set in severity field of the response in case there is a warning.
        Turned off by default
    .PARAMETER OnErrorAction
        Use this parameter to set the onerror status for nitro request. Applicable only for bulk requests.
        Acceptable values: "EXIT", "CONTINUE", "ROLLBACK", default to "EXIT"
    .PARAMETER Force
        Suppress confirmation when invoking operation on NetScaler API.
    .EXAMPLE
        Invoke NITRO REST API to add a DNS Server resource.
        $payload = @{ ip = "10.8.115.210" }
        Invoke-Nitro -Session $Session -Method POST -Type dnsnameserver -Payload $payload -Action add
    .OUTPUTS
        Only when the Method is GET:
        PSCustomObject that represents the JSON response content. This object can be manipulated using the ConvertTo-Json Cmdlet.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'high')]
    param (
        [PSObject]$Session = $script:session,

        [Parameter(Mandatory)]
        [ValidateSet('DELETE', 'GET', 'POST', 'PUT')]
        [string]$Method,

        [Parameter(Mandatory)]
        [string]$Type,

        [string]$Resource,

        [string]$Action,

        [hashtable]$Arguments = @{},

        [switch]$Stat = $false,

        [ValidateScript({$Method -eq 'GET'})]
        [hashtable]$Filters = @{},

        [ValidateScript({$Method -ne 'GET'})]
        [hashtable]$Payload = @{},

        [switch]$GetWarning = $false,

        [ValidateSet('EXIT', 'CONTINUE', 'ROLLBACK')]
        [string]$OnErrorAction = 'EXIT',

        [switch]$Force
    )

    if ($Method -eq 'GET' -or $Force -or
           $PSCmdlet.ShouldProcess($Type, "Invoke Nitro API $Method method")) {
        $InvokeArgs = $PSBoundParameters
        $InvokeArgs.Remove('Force') > $Null
        $InvokeArgs.Remove('Confirm') > $Null
        if (!$PSBoundParameters.ContainsKey('Session')) {
            $InvokeArgs['Session'] = $Session
        }

        _InvokeNSRestApi @InvokeArgs
    }
}
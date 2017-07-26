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

function Get-NSResponderAction {
    <#
    .SYNOPSIS
        Gets the specified responder action object.

    .DESCRIPTION
        Gets the specified responder action object.

    .EXAMPLE
        Get-NSResponderAction

        Get all responder action objects

    .EXAMPLE
        Get-NSResponderAction -Name 'act-redirect'

        Get the responder action named act-redirect.

    .EXAMPLE
        Get-NSResponderAction -Name /redir/

        Get all the responder actions whose name matches '.*redir.*' (NS treats this as a regex).

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        A filter to apply to the responder action name value.

    .PARAMETER Type
        A filter to apply to the responder action type value.

    .PARAMETER Target
        A filter to apply to the responder action target (expression) value.

    .PARAMETER HtmlPage
        A filter to apply to the responder action html page value.

    .PARAMETER ResponseStatusCode
        A filter to apply to the responder action response status code value.

    .PARAMETER Hits
        A filter to apply to the responder action hits value.

    .PARAMETER UndefHits
        A filter to apply to the responder action undefined hits value.

    .PARAMETER ReferenceCount
        A filter to apply to the responder action reference count value.

    #>
    [cmdletbinding()]
    param(
        $Session = $script:session,

        [Parameter(Position=0)]
        [string]$Name,

        [string]$Type,

        [Alias('Expression')]
        [string]$Target,

        [string]$HtmlPage,

        [string]$ResponseStatusCode,

        [string]$Hits,

        [Alias('UndefinedHits')]
        [string]$UndefHits,

        [string]$ReferenceCount
    )

    begin {
        _AssertSessionActive
        $response = @()
    }

    process {
        # Contruct a filter hash if we specified any filters
        $filters = @{}
        "Name","Type","Target","HtmlPage","ResponseStatusCode","Hits","UndefHits","ReferenceCount" | ForEach-Object {
            if ($PSBoundParameters.ContainsKey($_)) {
                $filters[$_.ToLower()] = (Get-Variable -Name $_).Value
            }
        }

        $response = _InvokeNSRestApi -Session $Session -Method Get -Type responderaction -Action Get -Filters $filters
        if ($response.errorcode -ne 0) { throw $response }
        if ($response.psobject.properties | Where-Object {$_.name -eq 'responderaction'}) {
            return $response.responderaction
        }
    }
}
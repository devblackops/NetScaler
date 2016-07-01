Param(
    [Parameter(Mandatory)]
    [String]$Name,

    [Parameter(Mandatory)]
    [String]$Type,

    [Parameter(Mandatory)]
    [String]$Label,
    
    [Hashtable]$Filters = $Null
)
    $ErrorActionPreference = "Stop"
    
    function Expand-FilterParam($Key, $Value) {
        "        [Parameter(ParameterSetName='search')]`n`n" + $(
        if ($Value[2] -eq "default") {
            "        [switch]`$$Key"
        } else {
            "        [string]`$$Key"
        })
    }

    function Expand-Filter($Key, $Value) {
        if ($Value[2] -eq "default") {
@"
        if (!`$$Key) {
            `$Filters['$($Value[0])'] = '$($Value[3])'
        }
"@
        } else {
@"
        if (`$PSBoundParameters.ContainsKey('$Key')) {
            `$Filters['$($Value[0])'] = `$$Key
        }
"@
        }
    }

    function Expand-FilterDoc($Key, $Value) {
@"
    .PARAMETER $Key
        $(if ($Value[2] -eq "default") {
          "If true, show builtins. Default value: $False"
        } else {
          "A filter to apply to the $($Value[1]) value."
        })
"@
    }


if ($Filters -and ($Filters.Count -ne 0)) {
    $ProcessBlock = @"
        # Contruct a filter hash if we specified any filters
        `$Filters = @{}
$(($Filters.GetEnumerator() | % { Expand-Filter $_.Key $_.Value }) -Join "`n")
        _InvokeNSRestApiGet -Session `$Session -Type $Type -Name `$Name -Filters `$Filters
"@
    $FilterParameters = ",`n`n" + (
        ($Filters.GetEnumerator() | % { Expand-FilterParam $_.Key $_.Value }) -Join ",`n`n"
    )
    $FilterDocs = "`n`n" + (
        ($Filters.GetEnumerator() | % { Expand-FilterDoc $_.Key $_.Value }) -Join "`n`n"
    )
} else {
 $ProcessBlock = @"
        _InvokeNSRestApiGet -Session `$Session -Type $Type -Name `$Name
"@
}

@"
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

function Get-NS$Name {
    <#
    .SYNOPSIS
        Gets the specified $Label object(s).

    .DESCRIPTION
        Gets the specified $Label object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NS$Name

        Get all $Label objects.

    .EXAMPLE
        Get-NS$Name -Name 'foobar'
    
        Get the $Label named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the $($Label)s to get.$FilterDocs
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        `$Session = `$Script:Session,

        [Parameter(Position=0, ParameterSetName='get')]
        [string[]]`$Name = @()$FilterParameters
    )

    begin {
        _AssertSessionActive
    }

    process {
$ProcessBlock
    }
}
"@ | Out-File -Encoding UTF8 -FilePath Netscaler\Public\Get-NS$Name.ps1
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
    
    function Expand-Filter($Key, $Value) {
@"
        if (`$PSBoundParameters.ContainsKey('$Key')) {
            `$Filters['$Value'] = (Get-Variable -Name '$Key').Value
        }
"@
    }

    function Expand-FilterDoc($Key, $Value) {
@"
    .PARAMETER $Key
        A filter to apply to the $Value value.
"@
    }


if ($Filters -and ($Filters.Length -ne 0)) {
    $ProcessBlock = @"
        # Contruct a filter hash if we specified any filters
        `$Filters = @{}
$(($Filters.GetEnumerator() | % { Expand-Filter $_.Key $_.Value[0] }) -Join "`n")
        _InvokeNSRestApiGet -Session `$Session -Type $Type -Name `$Name -Filters `$Filters
"@
    $FilterParameters = ",`n`n" + (
        ($Filters.Keys | %{ "        [string]`$$_" }) -Join ",`n`n"
    )
    $FilterDocs = "`n`n" + (
        ($Filters.GetEnumerator() | % { Expand-FilterDoc $_.Key $_.Value[1] }) -Join "`n`n"
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
        Gets the specified $Label object.

    .DESCRIPTION
        Gets the specified $Label object.

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
    [cmdletbinding()]
    param(
        `$Session = `$Script:Session,

        [Parameter(Position=0)]
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
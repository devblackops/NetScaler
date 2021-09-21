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

function Get-NSSystemFile {
    <#
    .SYNOPSIS
        Gets the specified system file object(s).

    .DESCRIPTION
        Gets the specified system file object(s).
        Either returns a single object identified by its name (-Name parameter)
        or a collection of objects filtered by the other parameters. Those
        filter parameters accept either a literal value or a regexp in the form
        "/someregexp/".

    .EXAMPLE
        Get-NSSystemFile

        Get all system file objects.

    .EXAMPLE
        Get-NSSystemFile -Name 'foobar'
    
        Get the system file named 'foobar'.

    .PARAMETER Session
        The NetScaler session object.

    .PARAMETER Name
        The name or names of the system files to get.

    .PARAMETER Filename
        A filter to apply to the file name value.

    .PARAMETER FileLocation
        A filter to apply to the file location value.
    #>
    [CmdletBinding(DefaultParameterSetName='get')]
    param(
        $Session = $Script:Session,

        [Parameter(Position=0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string[]]$Name = @(),

        [Parameter(ParameterSetName='search')]
        [string]$Filename,

        [Parameter(Mandatory)]
        [string]$FileLocation
    )

    begin {
        _AssertSessionActive
    }

    process {
        # Contruct a filter hash if we specified any filters
        $Filters = @{
            filelocation = $FileLocation
        }
        if ($PSBoundParameters.ContainsKey('Filename')) {
            $Filters['filename'] = $Filename
        }
        _InvokeNSRestApiGet -Session $Session -Type systemfile -Name $Name -Arguments $Filters
    }
}

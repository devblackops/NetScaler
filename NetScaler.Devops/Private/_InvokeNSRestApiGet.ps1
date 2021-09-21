function _InvokeNSRestApiGet {
    <#
    .SYNOPSIS
        Invoke NetScaler NITRO REST API GET method

    .DESCRIPTION
        Invoke NetScaler NITRO REST API GET method

    .PARAMETER Session
        An existing custom NetScaler Web Request Session object returned by Connect-NetScaler

    .PARAMETER Type
        Name of the NS appliance resource

    .PARAMETER Name
        The name or names of the NS appliance resources.

    .PARAMETER Filters
        A Hashtable of search filter values.

    .PARAMETER Arguments
        A Hashtable of arguments values.

    .EXAMPLE
        _InvokeNSRestApiGet -Session $Session -Type csaction -Name "ACT-rewrite-host"

        Retrieves the csaction named 'ACT-rewrite-host'.
        
    .OUTPUTS
        PSCustomObject that represents the JSON response content. This object can be manipulated using the ConvertTo-Json Cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSObject]$Session,

        [parameter(ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName)]
        [string[]]$Name = @(),

        [string]$Type,
        
        [Hashtable]$Filters = @{},
        
        [Hashtable]$Arguments = @{}
    )

    if ($Name.Count -gt 0) {
        foreach ($item in $Name) {
            $response = _InvokeNSRestApi -Session $Session -Method Get -Type $Type -Resource $item -Action Get -Filters $Filters -Arguments $Arguments
            if ($response.errorcode -ne 0) { throw $response }
            if ($Response.psobject.properties.name -contains $Type) {
                $response.$Type
            }
        }
    } else {
        $response = _InvokeNSRestApi -Session $Session -Method Get -Type $Type -Action Get -Filters $Filters -Arguments $Arguments
        if ($response.errorcode -ne 0) { throw $response }
        if ($Response.psobject.properties.name -contains $Type) {
            $response.$Type
        }
    }
}

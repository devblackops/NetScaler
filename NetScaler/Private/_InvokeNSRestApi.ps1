function _InvokeNSRestApi {
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
    .PARAMETER Payload
        Payload  of the web request, in hashtable format
    .PARAMETER GetWarning
        Switch parameter, when turned on, warning message will be sent in 'message' field and 'WARNING' value is set in severity field of the response in case there is a warning.
        Turned off by default
    .PARAMETER OnErrorAction
        Use this parameter to set the onerror status for nitro request. Applicable only for bulk requests.
        Acceptable values: "EXIT", "CONTINUE", "ROLLBACK", default to "EXIT"
    .EXAMPLE
        Invoke NITRO REST API to add a DNS Server resource.
        $payload = @{ip="10.8.115.210"}
        _InvokeNSRestApi -Session $Session -Method POST -Type dnsnameserver -Payload $payload -Action add
    .OUTPUTS
        Only when the Method is GET:
        PSCustomObject that represents the JSON response content. This object can be manipulated using the ConvertTo-Json Cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSObject]$Session,

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
        [string]$OnErrorAction = 'EXIT'
    )

    if ($Stat) {
        $uri = $Session.CreateUri("stat", $Type)
    } else {
        $uri = $Session.CreateUri("config", $Type)
    }

    if (-not [string]::IsNullOrEmpty($Resource)) {
        $uri += "/$Resource"
    }
    if ($Method -ne 'GET') {
        if (-not [string]::IsNullOrEmpty($Action)) {
            $uri += "?action=$Action"
        }

        if ($Arguments.Count -gt 0) {
            $queryPresent = $true
            if ($uri -like '*?action*') {
                $uri += '&args='
            } else {
                $uri += '?args='
            }
            $argsList = @()
            foreach ($arg in $Arguments.GetEnumerator()) {
                $argsList += "$($arg.Name):$([System.Uri]::EscapeDataString($arg.Value))"
            }
            $uri += $argsList -join ','
        }


    } else {
        $queryPresent = $false
        if ($Arguments.Count -gt 0) {
            $queryPresent = $true
            $uri += '?args='
            $argsList = @()
            foreach ($arg in $Arguments.GetEnumerator()) {
                $argsList += "$($arg.Name):$([System.Uri]::EscapeDataString($arg.Value))"
            }
            $uri += $argsList -join ','
        }
        if ($Filters.Count -gt 0) {
            $uri += if ($queryPresent) { '&filter=' } else { '?filter=' }
            $filterList = @()
            foreach ($filter in $Filters.GetEnumerator()) {
                $filterList += "$($filter.Name):$([System.Uri]::EscapeDataString($filter.Value))"
            }
            $uri += $filterList -join ','
        }
        #TODO: Add filter, view, and pagesize
    }
    Write-Verbose -Message "URI: $uri"

    $jsonPayload = $null
    if ($Method -ne 'GET') {
        $warning = if ($GetWarning) { 'YES' } else { 'NO' }
        $hashtablePayload = @{}
        $hashtablePayload.'params' = @{'warning' = $warning; 'onerror' = $OnErrorAction; <#"action"=$Action#>}
        $hashtablePayload.$Type = $Payload
        $jsonPayload = ConvertTo-Json -InputObject $hashtablePayload -Depth 100
        Write-Verbose -Message "JSON Payload:`n$jsonPayload"
    }

    $response = $null
    $restError = $null
    try {
        $restError = @()
        $restParams = @{
            Uri = $uri
            ContentType = 'application/json'
            Method = $Method
            WebSession = $Session.WebSession
            ErrorVariable = 'restError'
            Verbose = $false
        }

        if ($Method -ne 'GET') {
            $restParams.Add('Body', $jsonPayload)
        }

        $response = Invoke-RestMethod @restParams

        if ($response) {
            if ($response.severity -eq 'ERROR') {
                throw "Error. See response: `n$($response | Format-List -Property * | Out-String)"
            } else {
                Write-Verbose -Message "Response:`n$(ConvertTo-Json -InputObject $response | Out-String)"
                if ($Method -eq "GET") { return $response }
            }
        }
    }
    catch [Exception] {
        if ($Type -eq 'reboot' -and $restError[0].Message -eq 'The underlying connection was closed: The connection was closed unexpectedly.') {
            Write-Verbose -Message 'Connection closed due to reboot'
        } else {
            throw $_
        }
    }
}
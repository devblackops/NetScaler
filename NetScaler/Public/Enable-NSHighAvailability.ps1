<#
Copyright 2017 Dominique Broeglin

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

function Enable-NSHighAvailability {
    <#
    .SYNOPSIS
        Enable high-availability between two NetScaler instances.

    .DESCRIPTION
        Enable high-availability between two NetScaler instances.

    .EXAMPLE
        Enable-NSHighAvailability -PrimarySession $ns1 -SecondarySession Session $ns2

        Enable high-availability between the netscaler instances corresponding to
        the already opened $ns1 and $ns2.

    .PARAMETER PrimarySession
        The NetScaler session object for the first NetScaler instance (will end up master).

    .PARAMETER SecondarySession
        The NetScaler session object for the second NetScaler instance (will end up slave).

    .PARAMETER PeerNodeId
        The node id used to denote the peer.

        Default value: 1

    .PARAMETER Timeout
        Time to wait, in secondes, for the synchronization to complete.

        Default value: 300

    .PARAMETER Save
        If true, wait for the synchronization to finish and save configurations.

    .PARAMETER Force
        Suppress confirmation when activating high-availability.
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact='High')]
    param(
        [parameter(Mandatory)]
        $PrimarySession,

        [parameter(Mandatory)]
        $SecondarySession,

        [int]$PeerNodeId = 1,

        [int]$Timeout = 300,

        [switch]$Save,

        [switch]$Force
    )

    begin {
        _AssertSessionActive -Session $PrimarySession
        _AssertSessionActive -Session $SecondarySession
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess(
            "Enable high-availability of $($PrimarySession.Endpoint) and $($SecondarySession.Endpoint)")) {
            try {
                $primaryIp   = $PrimarySession.Endpoint
                $secondaryIp = $SecondarySession.Endpoint

                Write-Verbose "$primaryIp -> STAYPRIMARY..."
                _InvokeNSRestApi -Session $PrimarySession -Method PUT -Type hanode `
                    -Payload @{ id = 0; hastatus = "STAYPRIMARY" }

                Write-Verbose "$secondaryIp -> STAYSECONDARY..."
                _InvokeNSRestApi -Session $SecondarySession -Method PUT -Type hanode `
                    -Payload @{ id = 0; hastatus = "STAYSECONDARY" }

                Write-Verbose "$primaryIp -> set secondatory to $secondaryIp..."
                _InvokeNSRestApi -Session $PrimarySession -Method POST -Type hanode `
                    -Payload @{ id = $PeerNodeId; ipaddress = $secondaryIp } -Action add

                Write-Verbose "$secondaryIp -> set secondatory to $primaryIp..."
                _InvokeNSRestApi -Session $SecondarySession -Method POST -Type hanode `
                    -Payload @{ id = $PeerNodeId; ipaddress = $primaryIp } -Action Add

                Write-Verbose "$primaryIp -> ENABLED..."
                _InvokeNSRestApi -Session $PrimarySession -Method PUT -Type hanode `
                    -Payload @{ id = 0; hastatus = "ENABLED" }

                Write-Verbose "$secondaryIp -> ENABLED..."
                _InvokeNSRestApi -Session $SecondarySession -Method PUT -Type hanode `
                    -Payload @{ id = 0; hastatus = "ENABLED" }

                if ($Save) {
                    $waitStart = Get-Date

                    while (((Get-Date) - $waitStart).TotalSeconds -lt $Timeout) {
                        Write-Verbose "Waiting for synchronization to complete..."
                        Start-Sleep -Seconds 5
                        $HaNode = Get-NSHaNode -Session $PrimarySession -Id $PeerNodeId

                        if ($HaNode.hasync -match "IN PROGRESS|ENABLED") {
                            Write-Verbose "Synchronizing..." 
                            continue  
                        } elseif ($HaNode.hasync -eq "SUCCESS") {
                            Write-Verbose "Synchronization succesful. Saving configurations..."
                            Save-NSConfig -Session $PrimarySession
                            Save-NSConfig -Session $SecondarySession
                            break
                        } else {
                            throw "Unexpected sync status '$($HaNode.hasync)'"
                        }                
                    }

                    if ($HaNode.hasync -ne "SUCCESS") {
                        throw "Timeout expired before the synchronization ended. Configurations will not be saved!"
                    }
                }
            } catch {
                throw $_
            }
        }
    }
}
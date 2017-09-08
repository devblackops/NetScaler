<#
Copyright 2017 Ryan Butler

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

function Get-NSlicenseExpiration {
<#
.SYNOPSIS
    Grabs Netscaler license expiration information via REST
.DESCRIPTION
    Grabs Netscaler license expiration information via REST.
.PARAMETER NSSession
    An existing custom NetScaler Web Request Session object returned by Connect-NSAppliance
.EXAMPLE
    Get-NSlicenseExpiration -Session $Session
.NOTES
    Author: Ryan Butler - @ryan_c_butler
    Date Created: 09-07-2017
#>
[CmdletBinding()]
param (
[Parameter(Mandatory=$true)] [PSObject]$Session
)

begin{
    _AssertSessionActive
    #Grabs current time from Netscaler
    $currentnstime = Get-NSCurrentTime -Session $Session
    $results = @()
}

process {
    
    try {
        $lics = Get-NSSystemFile -Session $Session -filelocation "/nsconfig/license"|Where-Object {$_.filename -like "*.lic"}
    }
    Catch{
        throw "Error reading license(s)"
    }
    
    foreach ($lic in $lics)
    {
        Write-verbose "Reading $($lic.filename)"
            
        #Converts returned value from BASE64 to UTF8
        $lic = Get-NSSystemFile -Session $Session -filelocation "/nsconfig/license" -filename $lic.filename
        $info = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($lic.filecontent))
            
        #Grabs needed line that has licensing information
        $lines = $info.Split("`n")|where-object{$_ -like "*INCREMENT*"}
        
        #Parses needed date values from string
        $licdates = @()
        foreach ($line in $lines)
        {
            $licdate = $line.Split()
        
            if ($licdate[4] -like "permanent")
            {
                $expire = "PERMANENT"
            }
            else
            {
                $expire = [datetime]$licdate[4]
            }
        
            #adds date to object
            $temp = New-Object PSObject -Property @{
                        expdate = $expire
                        feature = $licdate[1]
                        }
            $licdates += $temp
        }
        
        foreach ($date in $licdates)
        {
            if ($date.expdate -like "PERMANENT")
            {
                $expires = "PERMANENT"
                $span = "9999"
            }
            else
            {
                $expires = ($date.expdate).ToShortDateString()
                $span = (New-TimeSpan -Start $currentnstime -end ($date.expdate)).days
            }
        
            $temp = New-Object PSObject -Property @{
                Expires = $expires
                Feature = $date.feature
                DaysLeft = $span
                LicenseFile = $lic.filename
                }
            $results += $temp    
        }    
        
    }
}

end{
    return $results
    }
}


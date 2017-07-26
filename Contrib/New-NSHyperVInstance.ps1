<#
    .SYNOPSIS
        Generates a new Hyper-V Netscaler instance from a Netscaler VPX package.

    .PARAMETER Package
        Location of the VPX package to use.

    .PARAMETER Path
        Location where the virtual machine will be created.

    .PARAMETER VMName
        Name of the created VM.

    .PARAMETER SwitchName
        Name of the switch the network adapter of the created instance will
        be connected to.

    .PARAMETER MacAddress
        MAC address to set for the VM network interface.
        Defaults to: "00155D7E3100"

    .PARAMETER Force
        If the VM is already present destroy it and create a new one.

    .PARAMETER NSIP
        NSIP to auto-provision the instane with.

    .PARAMETER Netmask
        Netmask to auto-provision the instane with.

    .PARAMETER DefaultGateway
        Default gateway to auto-provision the instane with

    .EXAMPLE
        New-NSHyperVInstance.ps1 -Verbose -Package C:\temp\NSVPX-HyperV-11.1-50.10_nc.zip `
            -VMName NSVPX-11-1 `
            -SwitchName Labnet `
            -NSIP 10.0.0.30 -DefaultGateway 10.0.0.254 `
            -Path C:\temp\NSVPX-11-1 `
            -Force

        Create a new NetScaler Hyper-V VM named 'NSVPX-11-1' in directory 'c:\temp\NSVPX-11-1'
        from the given VPX package. 
        Auto-provision it with NSIP 10.0.0.30/24 default gateway 10.0.0.254 on switch 
        'Labnet'. If the VM already exists, remove it first. 

    .NOTES
        Copyright 2017 Dominique Broeglin¨

        MIT License
        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the ""Software""), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:
        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.
        THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.

        We reuse the New-ISOFile function available here:
        https://gallery.technet.microsoft.com/scriptcenter/New-ISOFile-function-a8deeffd

    .LINK
        TODO
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory)]
    [String]$Package,

    [Parameter(Mandatory)]
    # This is a safeguard to prevent deleting our whole disk...
    [ValidateScript({$_.Length -ge 4})]
    [String]$Path,

    [Parameter(Mandatory)]
    [String]$VMName,

    [Parameter(Mandatory)]
    [String]$SwitchName,

    [Parameter(Mandatory)]
    [ValidateScript({$_ -as [ipaddress]})]
    [String]$NSIP,

    [ValidateScript({$_ -as [ipaddress]})]
    [String]$Netmask = "255.255.255.0",

    [Parameter(Mandatory)]
    [ValidateScript({$_ -as [ipaddress]})]
    [String]$DefaultGateway,

    [ValidatePattern("[0-9A-F]{8}")]
    [String]$MacAddress = "00155D7E3100",

    [Switch]$Force
)
$ErrorActionPreference = "Stop"

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    New-Item -ItemType Directory -Path (Join-Path $parent $name)
}

# Source: https://gallery.technet.microsoft.com/scriptcenter/New-ISOFile-function-a8deeffd
function New-IsoFile
{
  <#
   .Synopsis
    Creates a new .iso file
   .Description
    The New-IsoFile cmdlet creates a new .iso file containing content from chosen folders
   .Example
    New-IsoFile "c:\tools","c:Downloads\utils"
    This command creates a .iso file in $env:temp folder (default location) that contains c:\tools and c:\downloads\utils folders. The folders themselves are included at the root of the .iso image.
   .Example
    New-IsoFile -FromClipboard -Verbose
    Before running this command, select and copy (Ctrl-C) files/folders in Explorer first.
   .Example
    dir c:\WinPE | New-IsoFile -Path c:\temp\WinPE.iso -BootFile "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\efisys.bin" -Media DVDPLUSR -Title "WinPE"
    This command creates a bootable .iso file containing the content from c:\WinPE folder, but the folder itself isn't included. Boot file etfsboot.com can be found in Windows ADK. Refer to IMAPI_MEDIA_PHYSICAL_TYPE enumeration for possible media types: http://msdn.microsoft.com/en-us/library/windows/desktop/aa366217(v=vs.85).aspx
   .Notes
    NAME:  New-IsoFile
    AUTHOR: Chris Wu
    LASTEDIT: 03/23/2016 14:46:50
 #>

  [CmdletBinding(DefaultParameterSetName='Source')]Param(
    [parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true, ParameterSetName='Source')]$Source,
    [parameter(Position=2)][string]$Path = "$env:temp\$((Get-Date).ToString('yyyyMMdd-HHmmss.ffff')).iso",
    [ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$BootFile = $null,
    [ValidateSet('CDR','CDRW','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','BDR','BDRE')][string] $Media = 'DVDPLUSRW_DUALLAYER',
    [string]$Title = (Get-Date).ToString("yyyyMMdd-HHmmss.ffff"),
    [switch]$Force,
    [parameter(ParameterSetName='Clipboard')][switch]$FromClipboard
  )

  Begin {
    ($cp = new-object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = '/unsafe'
    if (!('ISOFile' -as [type])) {
      Add-Type -CompilerParameters $cp -TypeDefinition @'
public class ISOFile
{
  public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks)
  {
    int bytes = 0;
    byte[] buf = new byte[BlockSize];
    var ptr = (System.IntPtr)(&bytes);
    var o = System.IO.File.OpenWrite(Path);
    var i = Stream as System.Runtime.InteropServices.ComTypes.IStream;

    if (o != null) {
      while (TotalBlocks-- > 0) {
        i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes);
      }
      o.Flush(); o.Close();
    }
  }
}
'@
    }

    if ($BootFile) {
      if('BDR','BDRE' -contains $Media) { Write-Warning "Bootable image doesn't seem to work with media type $Media" }
      ($Stream = New-Object -ComObject ADODB.Stream -Property @{Type=1}).Open()  # adFileTypeBinary
      $Stream.LoadFromFile((Get-Item -LiteralPath $BootFile).Fullname)
      ($Boot = New-Object -ComObject IMAPI2FS.BootOptions).AssignBootImage($Stream)
    }

    $MediaType = @('UNKNOWN','CDROM','CDR','CDRW','DVDROM','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','HDDVDROM','HDDVDR','HDDVDRAM','BDROM','BDR','BDRE')

    Write-Verbose -Message "Selected media type is $Media with value $($MediaType.IndexOf($Media))"
    ($Image = New-Object -com IMAPI2FS.MsftFileSystemImage -Property @{VolumeName=$Title}).ChooseImageDefaultsForMediaType($MediaType.IndexOf($Media))

    if (!($Target = New-Item -Path $Path -ItemType File -Force:$Force -ErrorAction SilentlyContinue)) { Write-Error -Message "Cannot create file $Path. Use -Force parameter to overwrite if the target file already exists."; break }
  }

  Process {
    if($FromClipboard) {
      if($PSVersionTable.PSVersion.Major -lt 5) { Write-Error -Message 'The -FromClipboard parameter is only supported on PowerShell v5 or higher'; break }
      $Source = Get-Clipboard -Format FileDropList
    }

    foreach($item in $Source) {
      if($item -isnot [System.IO.FileInfo] -and $item -isnot [System.IO.DirectoryInfo]) {
        $item = Get-Item -LiteralPath $item
      }

      if($item) {
        Write-Verbose -Message "Adding item to the target image: $($item.FullName)"
        try { $Image.Root.AddTree($item.FullName, $true) } catch { Write-Error -Message ($_.Exception.Message.Trim() + ' Try a different media type.') }
      }
    }
  }

  End {
    if ($Boot) { $Image.BootImageOptions=$Boot }
    $Result = $Image.CreateResultImage()
    [ISOFile]::Create($Target.FullName,$Result.ImageStream,$Result.BlockSize,$Result.TotalBlocks)
    Write-Verbose -Message "Target image ($($Target.FullName)) has been created"
    $Target
  }
}

function Write-UserData {
    Param(
        [String]$NSIP,
        [String]$Netmask,
        [String]$DefaultGateway,
        [String]$DestinationPath
    )

    [xml]$userdata = @"
<?xml version="1.0" encoding="UTF-8" standalone="no" ?>
<Environment xmlns:oe="http://schemas.dmtf.org/ovf/environment/1"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
oe:id=""
xmlns="http://schemas.dmtf.org/ovf/environment/1">
<PlatformSection>
<Kind>HYPER-V</Kind>
<Version>2013.1</Version>
<Vendor>CISCO</Vendor>
<Locale>en</Locale>
</PlatformSection>
<PropertySection>
<Property oe:key="com.citrix.netscaler.ovf.version" oe:value="1.0"/>
<Property oe:key="com.citrix.netscaler.platform" oe:value="NS1000V"/>
<Property oe:key="com.citrix.netscaler.orch_env" oe:value="cisco-orch-env"/>
<Property oe:key="com.citrix.netscaler.mgmt.ip" oe:value=""/>
<Property oe:key="com.citrix.netscaler.mgmt.netmask" oe:value=""/>
<Property oe:key="com.citrix.netscaler.mgmt.gateway" oe:value=""/>
</PropertySection>
</Environment>
"@

    $userdata.Environment.PropertySection.Property | ForEach-Object {
        $Property = $_
        switch ($Property.key) {
            "com.citrix.netscaler.mgmt.ip"      { $Property.value = $NSIP } 
            "com.citrix.netscaler.mgmt.netmask" { $Property.value = $Netmask } 
            "com.citrix.netscaler.mgmt.gateway" { $Property.value = $DefaultGateway } 
        } 
    }

    $userdata.save($DestinationPath)
}

function Wait-NS {
    Param(
        $ip                      = $NSIP,
        $WaitTimeout             = 120,
        [ScriptBlock]$AfterBlock
    )
    $ip = $nsip
    $canWait = $true
    $WaitTimeout = 180
    $ping = New-Object -TypeName System.Net.NetworkInformation.Ping
    if ($True) {
        $waitStart = Get-Date
        Write-Verbose -Message 'Trying to ping until unreachable to ensure reboot process'
        while ($canWait -and $($ping.Send($ip, 2000)).Status -eq [System.Net.NetworkInformation.IPStatus]::Success) {
            if ($($(Get-Date) - $waitStart).TotalSeconds -gt $WaitTimeout) {
                $canWait = $false
                break
            } else {
                Write-Verbose -Message 'Still reachable. Pinging again...'
                Start-Sleep -Seconds 2
            }
        } 

        if ($canWait) {
            Write-Verbose -Message 'Trying to reach Nitro REST API to test connectivity...'
            while ($canWait) {
                $connectTestError = $null
                $response = $null
                try {
                    $params = @{
                        Uri = "http://$ip/nitro/v1/config"
                        Method = 'GET'
                        ContentType = 'application/json'
                        ErrorVariable = 'connectTestError'
                    }
                    $response = Invoke-RestMethod @params
                }
                catch {
                    if ($connectTestError) {
                        if ($connectTestError.InnerException.Message -eq 'The remote server returned an error: (401) Unauthorized.') {
                            break
                        } elseif ($($(Get-Date) - $waitStart).TotalSeconds -gt $WaitTimeout) {
                            $canWait = $false
                            break
                        } else {
                            Write-Verbose -Message 'Nitro REST API is not responding. Trying again...'
                            Start-Sleep -Seconds 5
                        }
                    }
                }
                if ($response) {
                    break
                }
            }
        }

        if ($canWait) {
            Write-Verbose -Message 'NetScaler appliance is back online.'
            & $AfterBlock
        } else {
            throw 'Timeout expired. Unable to determine if NetScaler appliance is back online.'
        }
    }

}

if($Force -and (Get-VM -Name $VMName -ErrorAction SilentlyContinue)) {
    Write-Verbose "Removing existing VM '$VMName'..."
    Remove-VM -Name $VMName -Force
}

$TempDir = New-TemporaryDirectory
Write-Verbose "Expanding package '$Package' into '$TempDir'..."

try {
    Expand-Archive -Path $Package -DestinationPath $TempDir
    $Vhd = Get-ChildItem -Recurse -Path $TempDir -Include Dynamic.vhd

    if (-not($Vhd)) {
        Write-Error "Unable to find Dynamic.vhd file in the expanded archive"
        return
    }

    if (Test-Path $Path) {
        Write-Warning "Path '$Path' already exists!"

        if ($Force) {
            Write-Verbose "Removing '$Path'..."
            Remove-Item -Recurse $Path
        } else {
            Write-Error "Exiting. If you want to replace the existing VM use -Force."
        }
    }

    New-Item -ItemType Directory -Path $Path > $Null

    $Vhdx = Join-Path $Path "$VMName.vhdx"
    Write-Verbose "Converting VHD to '$Vhdx'..."
    Convert-VHD -Path $Vhd -DestinationPath $Vhdx -VHDType Dynamic

    Write-Verbose "Importing disk $Vhd..."
    New-VM -Name $VMName -MemoryStartupBytes 2GB -VHDPath $Vhdx
    Set-VMProcessor -VMName $VMName -Count 2

    Write-Verbose "Setting MAC address to '$MacAddress'..."
    Set-VMNetworkAdapter -VMName $VMName -StaticMacAddress $MacAddress
    Connect-VMNetworkAdapter -VMName $VMName -SwitchName $SwitchName

    $UserDataFile = Join-Path $TempDir "userdata"
    $UserDataISOFile = Join-Path $TempDir "userdata.iso"
    Write-Verbose "Creating userdata ISO..."
    Write-UserData -NSIP $NSIP -Netmask $Netmask -DefaultGateway $DefaultGateway `
        -DestinationPath $UserDataFile
    New-IsoFile -Media CDR -Source $UserDataFile -Path $UserDataISOFile

    Set-VMDvdDrive -VMName $VMName -Path $UserDataISOFile

    Start-VM -Name $VMName
    
    Wait-Ns -AfterBlock {
        Get-VMDvdDrive -VMName $VMName | ForEach-Object {
            $_ | Set-VMDvdDrive -Path $Null
        }
    }    
} finally {
    # This is a safeguard to prevent deleting our whole disk...
    if ($TempDir.Fullname.Length -ge 4) {
        Remove-Item -Recurse $TempDir -Force
    } else {
        # Prevent full disk wipe out
        Write-Error "Refusing to delete directory '$TempDir' (too short)"
    }
}
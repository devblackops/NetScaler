#
# Module manifest for module 'PSGet_NetScaler'
#
# Generated by: Brandon Olin
#
# Generated on: 4/20/2016
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'NetScaler.psm1'

# Version number of this module.
ModuleVersion = '1.2.0'

# ID used to uniquely identify this module
GUID = 'bd4390dc-a8ad-4bce-8d69-f53ccf8e4163'

# Author of this module
Author = 'Brandon Olin'

# Company or vendor of this module
CompanyName = 'Unknown'

# Copyright statement for this module
Copyright = '(c) 2015 Brandon Olin. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell module for interacting with Citrix NetScaler via the Nitro API'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Add-NSCertKeyPair',
    'Add-NSDnsNameServer',
    'Add-NSIPResource',
    'Add-NSLBVirtualServerBinding'
    'Add-NSRSAKey',
    'Add-NSServerCertificate',
    'Connect-NetScaler',
    'Disable-NSFeature',
    'Disable-NSLBMonitor',
    'Disable-NSLBServer',
    'Disable-NSLBVirtualServer',
    'Disable-NSMode',
    'Disconnect-NetScaler',
    'Enable-NSFeature',
    'Enable-NSLBMonitor',
    'Enable-NSLBServer',
    'Enable-NSLBVirtualServer',
    'Enable-NSMode',
    'Get-NSAvailableTimeZone',
    'Get-NSConfig',
    'Get-NSCSAction',
    'Get-NSCSPolicy',
    'Get-NSCSVirtualServer',
    'Get-NSFeature',
    'Get-NSHostname',
    'Get-NSLBMonitor',
    'Get-NSLBServer',
    'Get-NSLBServiceGroup',
    'Get-NSLBServiceGroupMemberBinding',
    'Get-NSLBStat',
    'Get-NSLBVirtualServer',
    'Get-NSLBVirtualServerBinding',
    'Get-NSResponderAction',
    'Get-NSResponderPolicy',
    'Get-NSRewriteAction',
    'Get-NSRewritePolicy',
    'Get-NSMode',
    'Get-NSNTPServer',
    'Get-NSSAMLAuthenticationPolicy',
    'Get-NSSAMLAuthenticationServer',
    'Get-NSSSLCertificateKey',
    'Get-NSVPNServer',
    'Get-NSVPNSessionPolicy',
    'Get-NSVPNSessionProfile',
    'Get-NSVPNVirtualServer',
    'Install-NSLicense',
    'Invoke-Nitro',
    'New-NSLBMonitor',
    'New-NSLBServer',
    'New-NSLBServiceGroup',
    'New-NSLBServiceGroupMember',
    'New-NSLBVirtualServer',
    'New-NSResponderAction',
    'Remove-NSLBMonitor',
    'Remove-NSLBServer',
    'Remove-NSLBServiceGroup',
    'Remove-NSLBVirtualServer',
    'Remove-NSLBVirtualServerBinding',
    'Remove-NSResponderAction',
    'Restart-NetScaler',
    'Save-NSConfig',
    'Set-NSHostname',
    'Set-NSLBServer',
    'Set-NSLBServiceGroup',
    'Set-NSLBVirtualServer',
    'Set-NSResponderAction',
    'Set-NSTimeZone'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Citrix','NetScaler','LoadBalancer'

        # A URL to the license for this module.
        LicenseUri = 'http://www.apache.org/licenses/LICENSE-2.0'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/devblackops/NetScaler'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '- Added Invoke-Nitro to wrap direct calls to _InvokeNSRestApi
- Added Get-NSConfig to retrieve NetScaler configuration (running or saved)
- Added Get/New/Set/Remove-NSResponderAction
- Modified Get-NSLBMonitor, Get-NSLBServer, Get-NSLBServiceGroup to only return 
  resources if there are resources to return.'

        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable
    
 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


<# 
    .summary
        Test that describes code.

    .PARAMETER Force
        Used to force any installations to occur without confirming with
        the user.
#>
[CmdletBinding()]
Param (
    [Boolean]$Force = $false
)

if (!$PSScriptRoot) # $PSScriptRoot is not defined in 2.0
{
    $PSScriptRoot = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
}
# Make sure MetaFixers.psm1 is loaded - it contains Get-TextFilesList
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'MetaFixers.psm1') -Force

# Load the TestHelper module which contains the *-ResourceDesigner functions
Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'TestHelper.psm1') -Force

$ErrorActionPreference = 'stop'
Set-StrictMode -Version latest

$RepoRoot = (Resolve-Path $PSScriptRoot\..).Path
$PSVersion = $PSVersionTable.PSVersion

# Install and/or Import xDSCResourceDesigner Module
if ($env:APPVEYOR) {
    # Running in AppVeyor so force silent install of xDSCResourceDesigner
    $PSBoundParameters.Force = $true
}

$xDSCResourceDesignerModuleName = "xDscResourceDesigner"
$xDSCResourceDesignerModulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\$xDSCResourceDesignerModuleName"
$xDSCResourceDesignerModule = Install-ModuleFromPowerShellGallery -ModuleName $xDSCResourceDesignerModuleName -ModulePath $xDSCResourceDesignerModulePath @PSBoundParameters

if ($xDSCResourceDesignerModule) {
    # Import the module if it is available
    $xDSCResourceDesignerModule | Import-Module -Force
}
else
{
    # Module could not/would not be installed - so warn user that tests will fail.
    Write-Warning -Message ( @(
        "The 'xDSCResourceDesigner' module is not installed. "
        "The 'PowerShell DSC resource modules' Pester Tests in Meta.Tests.ps1 "
        'will fail until this module is installed.'
        ) -Join '' )
}

# PSScriptAnalyzer requires PowerShell 5.0 or higher
if ($PSVersion.Major -ge 5)
{
    Write-Verbose -Verbose "Installing PSScriptAnalyzer"
    $PSScriptAnalyzerModuleName = "PSScriptAnalyzer"
    $PSScriptAnalyzerModulePath = "$env:USERPROFILE\Documents\WindowsPowerShell\Modules\$PSScriptAnalyzerModuleName"
    $PSScriptAnalyzerModule = Install-ModuleFromPowerShellGallery -ModuleName $PSScriptAnalyzerModuleName -ModulePath $PSScriptAnalyzerModulePath @PSBoundParameters

    if ($PSScriptAnalyzerModule) {
        # Import the module if it is available
        $PSScriptAnalyzerModule | Import-Module -Force
    }
    else
    {
        # Module could not/would not be installed - so warn user that tests will fail.
        Write-Warning -Message ( @(
            "The 'PSScriptAnalyzer' module is not installed. "
            "The 'PowerShell DSC resource modules' Pester Tests in Meta.Tests.ps1 "
            'will fail until this module is installed.'
            ) -Join '' )
    }
}
else
{
    Write-Verbose -Verbose "Skipping installation of PSScriptAnalyzer since it requires PSVersion 5.0 or greater. Used PSVersion: $($PSVersion)"
}

# The folder where this module is found
[String] $moduleRoot = Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path)

# Modify PSModulePath of the current PowerShell session.
# We want to make sure we always test the development version of the resource
# in the current build directory.
[String] $script:OldModulePath = $env:PSModulePath
[String] $NewModulePath = $script:OldModulePath
if (($NewModulePath.Split(';') | Select-Object -First 1) -ne $moduleRoot)
{
    # Add the ModuleRoot to the beginning if it is not already at the front.
    $env:PSModulePath = "$moduleRoot;$env:PSModulePath"
}

# Wrap tests in a try so that if anything goes wrong or user terminates we roll back
# any enviroment changes (e.g. $ENV:PSModulePath)
try
{
    Describe 'Text files formatting' {
    
        $allTextFiles = Get-TextFilesList $RepoRoot
    
        Context 'Files encoding' {

            It "Doesn't use Unicode encoding" {
                $unicodeFilesCount = 0
                $allTextFiles | %{
                    if (Test-FileUnicode $_) {
                        $unicodeFilesCount += 1
                        Write-Warning "File $($_.FullName) contains 0x00 bytes. It's probably uses Unicode and need to be converted to UTF-8. Use Fixer 'Get-UnicodeFilesList `$pwd | ConvertTo-UTF8'."
                    }
                }
                $unicodeFilesCount | Should Be 0
            }
        }

        Context 'Indentations' {

            It 'Uses spaces for indentation, not tabs' {
                $totalTabsCount = 0
                $allTextFiles | %{
                    $fileName = $_.FullName
                    $tabStrings = (Get-Content $_.FullName -Raw) | Select-String "`t" | % {
                        Write-Warning "There are tab in $fileName. Use Fixer 'Get-TextFilesList `$pwd | ConvertTo-SpaceIndentation'."
                        $totalTabsCount++
                    }
                }
                $totalTabsCount | Should Be 0
            }
        }
    }

    Describe 'PowerShell DSC resource modules' {
    
        # PSScriptAnalyzer requires PowerShell 5.0 or higher
        if ($PSVersion.Major -ge 5)
        {
            Context 'PSScriptAnalyzer' {
                It 'passes Invoke-ScriptAnalyzer' {

                    # Perform PSScriptAnalyzer scan.
                    # Using ErrorAction SilentlyContinue not to cause it to fail due to parse errors caused by unresolved resources.
                    # Many of our examples try to import different modules which may not be present on the machine and PSScriptAnalyzer throws parse exceptions even though examples are valid.
                    # Errors will still be returned as expected.
                    $excludedRules = @(
                        'PSAvoidUsingUserNameAndPassWordParams'
                    )
                    $PSScriptAnalyzerErrors = Invoke-ScriptAnalyzer -path $RepoRoot -Severity Error -Recurse -ErrorAction SilentlyContinue -ExcludeRule $excludedRules
                    if ($PSScriptAnalyzerErrors -ne $null) {
                        Write-Warning -Message 'There are PSScriptAnalyzer errors that need to be fixed:'
                        @($PSScriptAnalyzerErrors).Foreach( { Write-Warning -Message "$($_.Scriptname) (Line $($_.Line)): $($_.Message)" } )
                        Write-Warning -Message  'For instructions on how to run PSScriptAnalyzer on your own machine, please go to https://github.com/powershell/psscriptAnalyzer/'
                        $PSScriptAnalyzerErrors.Count | Should Be $null
                    }
                }      
            }
        }

        # Force convert to array
        $psm1Files = @(
            Get-ChildItem -Path $RepoRoot\DscResources -Recurse -Filter '*.psm1' -File |
                Foreach-Object {
                    # Ignore Composite configurations
                    # They requires additional resources to be installed on the box
                    if (-not ($_.Name -like '*.schema.psm1'))
                    {
                        $MofFileName = "$($_.BaseName).schema.mof"
                        $MofFilePath = Join-Path -Path $_.DirectoryName -ChildPath $MofFileName
                        if (Test-Path -Path $MofFilePath -ErrorAction SilentlyContinue)
                        {
                            Write-Output -InputObject $_
                        }
                    }
                }
        )

        if (-not $psm1Files) {
            Write-Verbose -Verbose 'There are no resource files to analyze'
        } else {

            Write-Verbose -Verbose "Analyzing $($psm1Files.Count) resources"

            Context 'Correctness' {

                function Get-ParseErrors
                {
                    param(
                        [Parameter(ValueFromPipeline=$True,Mandatory=$True)]
                        [string]$fileName
                    )    

                    $tokens = $null 
                    $errors = $null
                    $ast = [System.Management.Automation.Language.Parser]::ParseFile($fileName, [ref] $tokens, [ref] $errors)
                    return $errors
                }


                It 'all .psm1 files don''t have parse errors' {
                    $errors = @()
                    $psm1Files | ForEach-Object { 
                        $localErrors = Get-ParseErrors $_.FullName
                        if ($localErrors) {
                            Write-Warning "There are parsing errors in $($_.FullName)"
                            Write-Warning ($localErrors | Format-List | Out-String)
                        }
                        $errors += $localErrors
                    }
                    $errors.Count | Should Be 0
                }
            }

            foreach ($psm1file in $psm1Files) 
            {
                Context "Schema Validation of $($psm1file.BaseName)" {

                    It 'should pass Test-xDscResource' {
                        $result = Test-xDscResource -Name $psm1file.DirectoryName
                        $result | Should Be $true
                    }

                    It 'should pass Test-xDscSchema' {
                        $Splat = @{
                            Path = $psm1file.DirectoryName
                            ChildPath = "$($psm1file.BaseName).schema.mof"
                        }
                        $result = Test-xDscSchema -Path (Join-Path @Splat -Resolve -ErrorAction Stop)
                        $result | Should Be $true
                    }
                }
            }
        }
    }
}
finally
{
    # Restore PSModulePath
    if ($script:OldModulePath -ne $env:PSModulePath)
    {
        $env:PSModulePath = $OldModulePath
    }
}
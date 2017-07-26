[cmdletbinding()]
param(
    [string[]]$Task = 'default',

    [switch]$Help,

    [switch]$UpdateModules
)

function Resolve-Module {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$Name,

        [switch]$Update
    )

    Process {
        foreach ($moduleName in $Name) {
            $module = Get-Module -Name $moduleName -ListAvailable -Verbose:$false
            Write-Verbose -Message "Resolving [$($ModuleName)]"

            if ($module) {
                if ($PSBoundParameters.ContainsKey('UpdateModules')) {
                    $version = $module | Measure-Object -Property Version -Maximum | Select-Object -ExpandProperty Maximum
                    $galleryVersion = Find-Module -Name $moduleName -Repository PSGallery -Verbose:$false |
                        Measure-Object -Property Version -Maximum |
                        Select-Object -ExpandProperty Maximum

                    if ($version -lt $galleryVersion) {
                        Write-Verbose -Message "$($moduleName) Installed Version [$($Version.tostring())] is outdated. Installing Gallery Version [$($galleryVersion.tostring())]"

                        Install-Module -Name $moduleName -Repository PSGallery -Verbose:$false -Force
                        Import-Module -Name $moduleName -Verbose:$false -Force -RequiredVersion $galleryVersion
                    }
                }
                Write-Verbose -Message "Importing [$($moduleName)]"
                Import-Module -Name $moduleName -Verbose:$false -Force
            }
            else {
                Write-Verbose -Message "[$($moduleName)] Missing, installing Module"
                Install-Module -Name $moduleName -Repository PSGallery -Verbose:$false -Force
                Import-Module -Name $moduleName -Verbose:$false -Force -RequiredVersion $version
            }
        }
    }
}

Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

'BuildHelpers', 'psake', 'Pester', 'PSDeploy', 'PSScriptAnalyzer' | Resolve-Module -Update:$UpdateModules

if ($PSBoundParameters.ContainsKey('Help')) {
    Get-PSakeScriptTasks -buildFile "$PSScriptRoot\psake.ps1"
    return
}

Set-BuildEnvironment -Force

Invoke-psake -buildFile "$PSScriptRoot\psake.ps1" -taskList $Task -nologo -Verbose:$VerbosePreference
exit ( [int]( -not $psake.build_success ) )

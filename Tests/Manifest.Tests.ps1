$moduleName = 'NetScaler'
$modulePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path | Split-Path -Parent) -ChildPath $moduleName
$manifestPath = Join-Path -Path $modulePath -Child "$moduleName.psd1"
$manifestExists = (Test-Path -Path $manifestPath)

Describe 'Module manifest' {
    Context 'Validation' {

        It 'has a manifest' {
            $manifestExists | Should Be $true
        }

        if ($manifestExists) {
            $manifest = Test-ModuleManifest -Path $manifestPath
        }

        It 'has a valid manifest' {
            $manifest | Should Not Be $null
        }

        It 'has a valid root module' {
            $manifest.RootModule | Should Be "$moduleName.psm1"
        }

        It 'has a valid description' {
            $manifest.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $manifest.Author | Should Not BeNullOrEmpty
        }

        It 'has a valid guid' {
            { 
                [guid]::Parse($manifest.Guid) 
            } | Should Not throw
        }

        It 'has a valid copyright' {
            $manifest.CopyRight | Should Not BeNullOrEmpty
        }
    }
}
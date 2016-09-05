##
## This is commented out until we're ready to enforce tests for every function
##

# $sut = $env:BHPSModulePath

# $publicFunctions = Get-ChildItem -Path $sut\Public -File -Exclude '*.tests.ps1' -Recurse
# $privateFunctions = Get-ChildItem -Path $sut\Private -File -Exclude '*.tests.ps1' -Recurse

# describe 'Function Test Cverage' {
#     context 'Public' {
#         foreach ($file in $publicFunctions) {
#             $baseName = $file.BaseName
#             $dir = $file.DirectoryName
#             $testFile = "$dir\$BaseName.tests.ps1"

#             it "$BaseName has Pester test file" {
#                 Test-Path -Path $testFile | should be $true    
#             }
#         }
#     }

#     context 'Private' {
#         foreach ($file in $privateFunctions) {
#             $baseName = $file.BaseName
#             $dir = $file.DirectoryName
#             $testFile = "$dir\$BaseName.tests.ps1"

#             it "$BaseName has Pester test file" {
#                 Test-Path -Path $testFile | should be $true    
#             }
#         }
#     }
# }

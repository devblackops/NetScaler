# Taken with love from @juneb_get_help (https://raw.githubusercontent.com/juneb/PesterTDD/master/Module.Help.Tests.ps1)

# Get module commands
# Remove all versions of the module from the session. Pester can't handle multiple versions.
Get-Module $env:BHProjectName | Remove-Module
Import-Module $env:BHModulePath -Verbose:$false -ErrorAction Stop
$moduleVersion = (Test-ModuleManifest $env:BHPSModuleManifest | select -ExpandProperty Version).ToString()
$ms = [Microsoft.PowerShell.Commands.ModuleSpecification]@{ ModuleName = $env:BHProjectName; RequiredVersion = $moduleVersion }
$commands = Get-Command -FullyQualifiedModule $ms -CommandType Cmdlet, Function, Workflow  # Not alias

## When testing help, remember that help is cached at the beginning of each session.
## To test, restart session.

foreach ($command in $commands) {
    $commandName = $command.Name

    # The module-qualified command fails on Microsoft.PowerShell.Archive cmdlets
    $help = Get-Help $commandName -ErrorAction SilentlyContinue

    Describe "Test help for $commandName" {

        # If help is not found, synopsis in auto-generated help is the syntax diagram
        It "should not be auto-generated" {
            $help.Synopsis | Should Not BeLike '*`[`<CommonParameters`>`]*'
        }

        # Should be a description for every function
        It "gets description for $commandName" {
            $help.Description | Should Not BeNullOrEmpty
        }

        Context "Test example help for $commandName" {

            $examples = @($help.examples.example)

            # Should be at least one example
            It "$commandName contains at least one examplegets example code from $commandName" {
                $examples.Count -ge 1 | Should Be $true
            }

            for ($i = 0; $i -lt $examples.Count; $i++) {

                $example = $examples[$i]

                It "gets example $i code from $commandName" {
                    $example.Code | Should Not BeNullOrEmpty
                }

                It "gets example $i remarks from $commandName" {
                    $example.Remarks | Should Not BeNullOrEmpty
                }

                It "example $i code contains command $commandName" {
                    ## Command may be on the second line (within the remarks) so concatenate them
                    $example.Code + $example.remarks.Text | Should Match $commandName
                }
            }

        }

        Context "Test parameter help for $commandName" {

            $common = 'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable', 'OutBuffer', 'OutVariable',
            'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable', 'Confirm', 'Whatif'

            $parameters = $command.ParameterSets.Parameters | Sort-Object -Property Name -Unique | Where-Object { $_.Name -notin $common }
            $parameterNames = $parameters.Name

            ## Without the filter, WhatIf and Confirm parameters are still flagged in "finds help parameter in code" test
            $helpParameters = $help.Parameters.Parameter | Where-Object { $_.Name -notin $common } | Sort-Object -Property Name -Unique
            $helpParameterNames = $helpParameters.Name

            foreach ($parameter in $parameters) {
                $parameterName = $parameter.Name
                $parameterHelp = $help.parameters.parameter | Where-Object Name -EQ $parameterName

                # Should be a description for every parameter
                It "gets help for parameter: $parameterName : in $commandName" {
                    $parameterHelp.Description.Text | Should Not BeNullOrEmpty
                }

                # Required value in Help should match IsMandatory property of parameter
                It "help for $parameterName parameter in $commandName has correct Mandatory value" {
                    $codeMandatory = $parameter.IsMandatory.toString()
                    $parameterHelp.Required | Should Be $codeMandatory
                }

                # Parameter type in Help should match code
                # It "help for $commandName has correct parameter type for $parameterName" {
                #     $codeType = $parameter.ParameterType.Name
                #     # To avoid calling Trim method on a null object.
                #     $helpType = if ($parameterHelp.parameterValue) { $parameterHelp.parameterValue.Trim() }
                #     $helpType | Should be $codeType
                # }
            }

            foreach ($helpParm in $HelpParameterNames) {
                # Shouldn't find extra parameters in help.
                It "finds help parameter in code: $helpParm" {
                    $helpParm -in $parameterNames | Should Be $true
                }
            }
        }

        Context "Help Links should be Valid for $commandName" {
            $link = $help.relatedLinks.navigationLink.uri

            foreach ($link in $links) {
                if ($link) {
                    # Should have a valid uri if one is provided.
                    it "[$link] should have 200 Status Code for $commandName" {
                        $Results = Invoke-WebRequest -Uri $link -UseBasicParsing
                        $Results.StatusCode | Should Be '200'
                    }
                }
            }
        }
    }
}


describe 'Connect-NetScaler' {

    InModuleScope 'NetScaler' {

        $secPass = 'password' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential -ArgumentList ('user', $secPass)

        $mockSession = @{
            Endpoint = 'localhost'
            WebSession = [Microsoft.PowerShell.Commands.WebRequestSession]$null
        }

        $mockSuccessResponse = @{
            severity = 'SUCCESS'
        }

        $mockFailedResponse = @{
            severity = 'ERROR'
        } 

        mock -CommandName Invoke-RestMethod -MockWith { return $mockSuccessResponse }
        mock -CommandName Invoke-RestMethod -MockWith { return $mockFailedResponse } -ParameterFilter { $Timeout -eq 10 }

        context 'Session' {

            it 'Connects successfully' {
                {Connect-NetScaler -IPAddress '1.2.3.4' -Credential $credential} | should not throw
            }

            it 'Throws error on unsuccessfully log on' {
                { connect-NetScaler -IPAddress '1.2.3.4' -Credential $credential -Timeout 10 } | should throw
            }

            it 'Returns the session object' {
                $s = Connect-NetScaler -Hostname 'localhost' -Credential $credential -PassThru
                $s | should not benullorempty
                $script:session | should not benullorempty
            }

            it 'Connects via HTTPs' {
                Connect-NetScaler -Hostname 'localhost' -Credential $credential -HTTPs
                $script:protocol | should be 'https'
            }
        }

        context 'Validation' {

            it 'Validates IP address' {
                {Connect-NetScaler -IPAddress '.' -Credential $credential} | should throw
            }            
        }
    }
}

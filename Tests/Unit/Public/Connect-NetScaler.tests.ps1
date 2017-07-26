
describe 'Connect-NetScaler' {

    InModuleScope 'NetScaler' {

        $secPass = 'password' | ConvertTo-SecureString -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential -ArgumentList ('user', $secPass)

        $mockSession = . $env:BHProjectPath\Tests\Mocks\emptySession.ps1 
        $mockSuccessResponse = . $env:BHProjectPath\Tests\Mocks\loginSuccess.ps1
        $mockFailedResponse = . $env:BHProjectPath\Tests\Mocks\loginFailure.ps1

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

            it 'Connects via HTTP' {
                Connect-NetScaler -Hostname 'localhost' -Credential $credential
                $script:session.scheme | should be 'http'
            }

            it 'Connects via HTTPs' {
                Connect-NetScaler -Hostname 'localhost' -Credential $credential -HTTPs
                $script:session.scheme | should be 'https'
            }
        }

        context 'Validation' {

            it 'Validates IP address' {
                {Connect-NetScaler -IPAddress '.' -Credential $credential} | should throw
            }            
        }
    }
}

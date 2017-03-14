Import-Module Pester

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force $here\..\Netscaler\Netscaler.psd1
. $here\TestSupport.ps1

Describe "Netscaler Connection" {
    Context "not connected" {
        It "should disconnect implicit session" {
            $Session = Connect-TestNetscaler

            Get-NSHostname
            Disconnect-Netscaler
            { Get-NSHostname } | Should Throw "Unauthorized"
        }

        It "should disconnect explicit session" {
            $Session = Connect-TestNetscaler

            Get-NSHostname -Session $Session
            Disconnect-Netscaler -Session $Session
            { Get-NSHostname -Session $Session } | Should Throw "Unauthorized"
        }
    }

    Context "connection" {
    }
}

Describe "Netscaler Get-*" {
    $Session = Connect-TestNetscaler

    It "should get a certificate" {
        $Cert = Get-NSSSLCertificate -Name "ns-server-certificate"

        $Cert | Should Not BeNullOrEmpty
        $Cert.certkey | Should Be "ns-server-certificate"
    }

    It "should list certificates" {
        $Cert = Get-NSSSLCertificate

        $Cert | Should Not BeNullOrEmpty
        $Cert.certkey | Should Match "ns-server-certificate|ns-sftrust-certificate"
    }
}

Describe "Netscaler" {
    $Session = Connect-TestNetscaler

    It "should add a LB server" {
        New-NSLBServer -Name 'srv-test' -IPAddress 1.2.3.4

        Compare-NSConfig $OldConf | Should Match "=> add server srv-test 1.2.3.4"
    }

    It "should add features" {
        Enable-NSFeature -Force -Name "aaa", "lb", "rewrite", "ssl"

        Compare-NSConfig $OldConf | Should Match "=> enable ns feature LB SSL AAA REWRITE"
    }

    BeforeEach { $OldConf = Get-NSConfig }
    AfterEach { 
        Clear-NSConfig -Force -Level Full 
        # Web Logging and Surge Protection are not disabled by a config clear...
        "wl", "sp" | Disable-NSFeature -Force
    }
}
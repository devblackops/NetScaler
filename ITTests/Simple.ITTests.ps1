$Nsip              = "172.16.124.11"
$Username          = "nsroot"
$Password          = "nsroot"

Import-Module Pester

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force $here\..\Netscaler
. $here\TestSupport.ps1

Describe "Netscaler Get-*" {
    $Session = Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

    It "should list VPN policies" {
        $Policy = Get-NSVPNSessionPolicy
        
        $Policy | Should Not BeNullOrEmpty
        $Policy.name | Should Be "SETVPNPARAMS_POL" 
    }

    It "should get VPN policy" {
        $Policy = Get-NSVPNSessionPolicy -Name "SETVPNPARAMS_POL"
        
        $Policy | Should Not BeNullOrEmpty
        $Policy.name | Should Be "SETVPNPARAMS_POL"
    }

    It "should list VPN profiles" {
        $Policy = Get-NSVPNSessionProfile
        
        $Policy | Should Not BeNullOrEmpty
        $Policy.name | Should Be "SETVPNPARAMS_ACT" 
    }

    It "should get VPN profiles" {
        $Policy = Get-NSVPNSessionProfile -Name "SETVPNPARAMS_ACT"
        
        $Policy | Should Not BeNullOrEmpty
        $Policy.name | Should Be "SETVPNPARAMS_ACT"
    }
    
    It "should get a certificate" {
        $Cert = Get-NSSSLCertificate -Name "ns-server-certificate"

        $Cert | Should Not BeNullOrEmpty
        $Cert.certkey | Should Be "ns-server-certificate"
    }

    It "should list certificates" {
        $Cert = Get-NSSSLCertificate

        $Cert | Should Not BeNullOrEmpty
        $Cert.certkey | Should Be "ns-server-certificate"
    }
    
    It "should list builtin responder policies" {
        $Result = Get-NSResponderPolicy -ShowBuiltin
        
        $Result | Should Not BeNullOrEmpty
        # TODO: this is fragile, it probably depends on the NS version
        $Result.Count | Should Be 6
    }
    
    It "should list builtin rewrite actions" {
        $Result = Get-NSRewriteAction -ShowBuiltin
        
        $Result | Should Not BeNullOrEmpty
        # TODO: this is fragile, it probably depends on the NS version
        $Result.Count | Should Be 45
    }

    It "should list builtin rewrite policies" {
        $Result = Get-NSRewritePolicy -ShowBuiltin
        
        $Result | Should Not BeNullOrEmpty
        # TODO: this is fragile, it probably depends on the NS version
        $Result.Count | Should Be 49
    }
}

Describe "Netscaler" {
    $Session = Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

        
    It "should add a LB server" {
        New-NSLBServer -Name 'srv-test' -IPAddress 1.2.3.4
        
        Compare-NSConfig $OldConf | Should Match "=> add server srv-test 1.2.3.4"       
    }
    
    BeforeEach { $OldConf = Get-NSConfig }    
    AfterEach { Clear-NSConfig -Force }        
}
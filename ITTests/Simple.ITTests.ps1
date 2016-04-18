$Nsip              = "172.16.124.10"
$Username          = "nsroot"
$Password          = "nsroot"

Import-Module Pester

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module -Force $here\..\Netscaler

$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)    


function Compare-NSConfig($Old, $New) {
    $Old = $Old | ? { Test-IsMutatingConfigLines $_ }
    $New = $New | ? { Test-IsMutatingConfigLines $_ }
    Compare-Object $Old $New | % {
        "{0} {1}" -f $_.SideIndicator, $_.InputObject
    }
}

function Test-IsMutatingConfigLines($line) {
    !($_ -match "^set (ns encryptionParams|cluster rsskey|ns rpcNode)")
}

Describe "NS Feature" {
    $Session = Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru
    
    It "should add a feature1" {
        New-NSLBServer -Name toto -IPAddress 1.2.3.4
        $NewConfig = Get-NSConfig
        
        Write-Host (Compare-NSConfig $OldConfig $NewConfig)       
    }    

    It "should add a feature2" {
        New-NSLBServer -Name toto1 -IPAddress 1.2.3.5
        $NewConfig = Get-NSConfig
        
        Write-Host ((Compare-NSConfig $OldConfig $NewConfig) -join "`n")       
    }    

    BeforeEach {
        $OldConfig = Get-NSConfig        
    }
    
    AfterEach {
        Invoke-Nitro -Method POST -Type nsconfig -Action clear -Payload @{ "level" = "Basic"; "force" = "false"} -Force
    }
}
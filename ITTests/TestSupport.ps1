$TestNsip              = $(if ($env:TEST_NSIP) { $env:TEST_NSIP } else { "172.16.124.10" })
$TestUsername          = "nsroot"
$TestPassword          = "nsroot"

function Connect-TestNetscaler {
    $SecurePassword = ConvertTo-SecureString $TestPassword -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential ($TestUsername, $SecurePassword)    
    Connect-Netscaler -Hostname $TestNsip -Credential $Credential -PassThru   
}

function Compare-NSConfig($Old, $New = $(Get-NSConfig)) {
    $Old = $Old | Where-Object { Test-IsMutatingConfigLines $_ }
    $New = $New | Where-Object { Test-IsMutatingConfigLines $_ }
    Compare-Object $Old $New | ForEach-Object {
        "{0} {1}" -f $_.SideIndicator, $_.InputObject
    }
}

function Test-IsMutatingConfigLines($line) {
    !($_ -match "^set (ns encryptionParams|cluster rsskey|ns rpcNode)")
}
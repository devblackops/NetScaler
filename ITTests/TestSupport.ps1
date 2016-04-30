$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)    


function Compare-NSConfig($Old, $New = $(Get-NSConfig)) {
    $Old = $Old | ? { Test-IsMutatingConfigLines $_ }
    $New = $New | ? { Test-IsMutatingConfigLines $_ }
    Compare-Object $Old $New | % {
        "{0} {1}" -f $_.SideIndicator, $_.InputObject
    }
}

function Test-IsMutatingConfigLines($line) {
    !($_ -match "^set (ns encryptionParams|cluster rsskey|ns rpcNode)")
}
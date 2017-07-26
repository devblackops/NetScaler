# Notes about generating code for the module

## History

Our first shot a generating code for the module was to create an ad-hoc string interpolation based generator : `New-GetCmdlet.ps1`.

The actual generation process where we tell the cmdlet what to generate is defined
in `New-GetCmdlets.ps1`

However, this approach is very cumbersome and leads to a very hard do maintain 
generator. The preferred approach now is to use a template base generator. The generator is still a work in progress but you can take a look at https://github.com/dbroeglin/Forge.Netscaler if you are interested.

## Updating FunctionsToExport

    $list = (Get-ChildItem ./NetScaler/Public/ |
        Sort-Object Name |
        ForEach-Object { 
            $_.name -replace '(.*).ps1', "    '`$1'" 
        }) -join ",`r`n"
    [System.IO.File]::WriteAllText(
        "./Netscaler/Netscaler.psd1", (
            (
                Get-Content -Encoding UTF8 ./NetScaler/NetScaler.psd1 -Raw
            ) -replace "(?smi)(FunctionsToExport *= *@\()[^)]*(\))", 
        "`$1`r`n$list`r`n`$2"))


# Example code generation:

    New-NSGet -Name HANode -Label "HA Node" -Filters ([ordered]@{ 
        "Name"      = "name"
        "IPAddress" = "ipaddress"
        "State"     = "state"
        "HAStatus"  = "hastatus"
        "HASync"    = "hasync"
        }) -ResourceIdParamName ID -Partial



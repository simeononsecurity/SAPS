#https://github.com/simeononsecurity/SAPS

## Sets Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "ListAllComputersInDomain2CSV"
$file = "$scriptname-$computername-$timestamp.csv"
$outputpath = "C:\temp\Scripts\$scriptname"
$csvoutfile = "$path\$file"


## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

## Enables Get-ADComputer ##
import-module ActiveDirectory

## Lists all Domain Computers, Creates table with only Name information, Exports as CSV (EXCELL) document ##
Get-ADComputer -Filter * -Property * | Select-Object Name | Sort-Object Name | Export-CSV "$csvoutfile" -NoTypeInfo


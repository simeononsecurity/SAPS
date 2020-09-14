#https://github.com/simeononsecurity/SAPS

## Sets Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "AuditInstalledSoftware2CSV"
$file = "$scriptname-$computername-$timestamp.csv"
$outputpath = "C:\temp\Scripts\$scriptname"
$csvoutfile = "$path\$file"


## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

## Collects Installed Application and Software Information, Organises Information, & Saves Information into a Sorted CSV (EXCEL) File ##
Get-WmiObject -Namespace ROOT\CIMV2 -Class Win32_Product  | Select-Object Installdate, Name, Version, Vendor, PSComputerName | Sort-Object Installdate | Export-CSV $csvoutfile -NoTypeInfo

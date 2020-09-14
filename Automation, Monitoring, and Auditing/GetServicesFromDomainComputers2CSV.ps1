#https://github.com/simeononsecurity/SAPS

## Sets Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "GetServicesFromDomainComputers2CSV"
$file = "$scriptname-$computername-$timestamp.csv"
$outputpath = "C:\temp\Scripts\$scriptname"
$csvoutfile = "$path\$file"
## Specify username in $cred ##
$cred = Get-Credential     
$computers = "(Get-AdComputer -Filter *).Name"


## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

## Generates List of Services on all computers in $computers ##
ForEach ($Server in $computers) { 

    Invoke-Command -ComputerName $Server -Credential $cred -ScriptBlock {$computername = "$env:computername" ; $timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))" ; $scriptname = "GetServicesFromDomainComputers2CSV" ; $file = "$scriptname-$computername-$timestamp.csv" ; $outputpath = "C:\temp\Scripts\$scriptname" ; $csvoutfile = "$path\$file" ; If(!(test-path $outputpath)){New-Item -ItemType Directory -Force -Path $outputpath}; Get-WmiObject win32_service | select-object name, displayname, state, startmode, pathname | export-csv -Force -path "$csvoutfile"} -ArgumentList $cred

}

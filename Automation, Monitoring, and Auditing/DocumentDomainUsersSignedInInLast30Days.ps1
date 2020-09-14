#https://github.com/simeononsecurity/SAPS

## Sets Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "DocumentDomainUsersSignedInInLast30Days"
$file = "$scriptname-$computername-$timestamp.csv"
$outputpath = "C:\temp\Scripts\$scriptname"
$csvoutfile = "$path\$file"


## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

Get-ADUser -Filter {Enabled -eq $True} -Properties Name, LastLogonDate | Where-Object {$_.LastLogonDate -GT (Get-Date).AddDays(-30)} | select-object Name, LastLogonDate | export-csv $csvoutfile

#https://github.com/simeononsecurity/SAPS

## Sets Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "DocumentandDisableInactiveDomainAccounts-30Days"
$file = "$scriptname-$computername-$timestamp.csv"
$outputpath = "C:\temp\Scripts\$scriptname"
$csvoutfile = "$path\$file"

#Change these variables to reflect your OUs
$OU = "OU=Users,DC=example,DC=com"
$disabledOU = "OU=Disabled Users,DC=example,DC=com"

## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

Import-Module ActiveDirectory 

Get-ADUser -Filter {Enabled -eq $TRUE} -SearchBase $OU -Properties Name,SamAccountName,LastLogonDate | Where-Object {($_.LastLogonDate -lt (Get-Date).AddDays(-30)) -and ($_.LastLogonDate -ne $NULL)} | Disable-AdAccount
Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $OU -Properties Name,SamAccountName,LastLogonDate | Export-CSV $csvoutfile
Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $OU | Foreach-object { Move-ADObject -Identity $_.DistinguishedName -TargetPath $disabledOU}

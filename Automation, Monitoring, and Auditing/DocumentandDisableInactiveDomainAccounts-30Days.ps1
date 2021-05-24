#https://github.com/simeononsecurity/SAPS

## Set Environment Variables ##
$computername = "$env:computername"
$timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
$scriptname = "DocumentandDisableInactiveDomainAccounts-30Days"
$outputpath = "C:\temp\Output\Scripts\$scriptname"

#Change these variables to reflect your OUs
$OU = "OU=Users,DC=example,DC=com"
$disabledOU = "OU=Disabled Users,DC=example,DC=com"

## Creates Output Folder Structure if it Doesn't Exist ##
If(!(test-path $outputpath))
{
      New-Item -ItemType Directory -Force -Path $outputpath
}

Import-Module ActiveDirectory 

#Disable accounts not active in over 30 days in the OU specified in $OU
Get-ADUser -Filter {Enabled -eq $TRUE} -SearchBase $OU -Properties Name,EmailAddress,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-30)) -and ($_.LastLogonDate -ne $NULL)} | Disable-AdAccount

#Document the accounts that were disabled in $OU
$disabledhtmlfiletitle = "Disabled Accounts" + " " + (Get-Date)
Try {
    Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $OU -Properties Name,EmailAddress,SamAccountName,LastLogonDate | ConvertTo-HTML -Property Name,EmailAddress,SamAccountName,LastLogonDate -Title $disabledhtmlfiletitle -Head $disabledhtmlfiletitle | Out-File $outputpath\disabledaccount.$timestamp.html 
    Write-Host Disabled accounts log saved to $outputpath\disabledaccount.$timestamp.html
    Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $OU -Properties Name,EmailAddress,SamAccountName,LastLogonDate | Select-Object EmailAddress | Export-CSV -NoTypeInformation  $outputpath\disabledaccount.emails.$timestamp.csv 
    Write-Host Disabled account emails list saved to $outputpath\disabledaccount.emails.$timestamp.csv 
}
Catch {
    Write-Host "Error"
}


#Move disabled users in $OU to the $disabledOU OU
Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $OU | Foreach-object {Move-ADObject -Identity $_.DistinguishedName -TargetPath $disabledOU}

#Document accounts not signed in for 180 days and are pending deletion
$deletedhtmlfiletitle = "Deleted Accounts" + " " + (Get-Date)
Try {
    Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $disabledOU -Properties Name,EmailAddress,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-180)) -and ($_.LastLogonDate -ne $NULL)} | ConvertTo-HTML -Property Name,EmailAddress,SamAccountName,LastLogonDate -Title $deletedhtmlfiletitle -Head $deletedhtmlfiletitle | Out-File $outputpath\deletedaccounts.$timestamp.html
    Write-Host Deleted accounts log saved to $outputpath\deletedaccounts.$timestamp.csv
}
Catch {
    Write-Host "Error"
}

#Delete accounts not logged in over 180 days or aprox. a half a year.
#Will prompt for each deletion to confirm
Get-ADUser -Filter {Enabled -eq $FALSE} -SearchBase $disabledOU -Properties Name,EmailAddress,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-180)) -and ($_.LastLogonDate -ne $NULL)} | Remove-ADUser -Confirm


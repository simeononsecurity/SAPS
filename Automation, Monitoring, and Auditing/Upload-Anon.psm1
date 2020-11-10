function Upload-Anon {
#Requires -Version 6.0
param(
[string]$File 
)
If (!$File){
    Write-Host "Please provide the a file. Ex: Upload-Anon -File 'C:\temp\test.txt'"
}Else {
    Write-Host "Please wait wile the file is uploaded"
    (Invoke-WebRequest -Method "Post" -Uri "https://api.anonfiles.com/upload" -Form @{file=(Get-Item $File)}).content  -Split {$_ -eq '"' -or $_ -eq "{" -or $_ -eq "}" -or $_ -eq ',' -or $_ -eq ' '} | Select-String -NoEmphasis -Pattern 'https' |  Out-String | Set-Variable -Name links
    Write-Host "`n"
    Write-Host "Share your files with either of the following links"
    Write-Host "$links"
}
}




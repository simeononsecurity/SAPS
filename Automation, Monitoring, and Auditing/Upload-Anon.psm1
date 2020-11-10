function Upload-Anon {
param(
[string]$File 
)
If (!$File){
    Write-Host "Please provide the a file. Ex: Upload-Anon -File 'C:\temp\test.txt'"
}Else {
Invoke-WebRequest -Method "Post" -Uri "https://api.anonfiles.com/upload" -Form @{file=(Get-Item $File)}
}
}






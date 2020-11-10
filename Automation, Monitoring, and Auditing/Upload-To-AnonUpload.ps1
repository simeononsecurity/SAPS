Invoke-WebRequest -Method Post -Uri https://api.anonfiles.com/upload -Form @{file=(Get-Item .\result7.html)}

#Download all files from a website to current working directory.
## Note: This is not recursive. It will only download all files linked on the url in $url, it will not grab every file listed on every site linked in $url.


## Adjust the $url variable for your respective site.
$url = "https://rules.emergingthreats.net/open-nogpl/snort-2.9.0/rules/"
ForEach ($link in ((Invoke-WebRequest -Uri "$url").Links).href){
    Write-Output "$url$link"
    Wget "$url$link"
    }

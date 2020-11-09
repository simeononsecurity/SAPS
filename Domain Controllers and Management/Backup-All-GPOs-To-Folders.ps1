$domain = example.com
$gponamelist = (Get-GPO -All -Domain "$domain").DisplayName
#$gpoidlist = (Get-GPO -All -Domain "$domain").Id

Foreach ($gpo in $gponamelist){
    Mkdir C:\temp\GPOBackups\"$gpo" ; Backup-Gpo -Name "$gpo" -Path C:\temp\GPOBackups\"$gpo" 
}

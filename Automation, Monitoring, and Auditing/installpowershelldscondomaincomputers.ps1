##Install and Import AD Modules For Powershell v6
Install-Module -Name WindowsCompatibility
Import-Module -Name WindowsCompatibility 
Import-WinModule -Name ActiveDirectory

#Install and Import Powershell AD Module
Install-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory

$computerlist = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

##Schedule Update for EoD
Invoke-Command -Computer $computerlist -ScriptBlock {(Get-Module PowerStig -ListAvailable).RequiredModules | ForEach-Object {$PSItem | Install-Module -Force}}

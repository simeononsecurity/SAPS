##Install and Import AD Modules For Powershell v6
Install-Module -Name WindowsCompatibility
Import-Module -Name WindowsCompatibility 
Import-WinModule -Name ActiveDirectory

#Install and Import Powershell AD Module
Install-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory

$computerlist = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

##Schedule Update for EoD
Invoke-Command -Computer $computerlist -ScriptBlock {Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI"}

Invoke-Command -Computer $computerlist -ScriptBlock {Invoke-Expression "https://github.com/PowerShell/PowerShell/releases/download/v7.0.2/PowerShell-7.0.2-win-x64.msi" ; msiexec.exe /package PowerShell-7.0.1-win-x64.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1}

#winget install Microsoft.Powershell
#winget install Microsoft.Powershell-preview
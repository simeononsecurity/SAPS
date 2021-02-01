#https://github.com/simeononsecurity/SAPS

##Install and Import AD Modules For Powershell v6
Install-Module -Name WindowsCompatibility -Force
Import-Module -Name WindowsCompatibility -Force
Import-WinModule -Name ActiveDirectory -Force

#Install and Import Powershell AD Module
Install-WindowsFeature RSAT-AD-PowerShell -Force
Import-Module ActiveDirectory -Force

$computerlist = Get-ADComputer -Filter {Enabled -eq $True}
$finaldestination= Read-Host "Specify a Network Path to Copy Files to When Done"

ForEach ($computer in ($computerlist).Name){
    Invoke-Command -Computer $computer -ScriptBlock {
        $computername = "$env:computername"
        $timestamp = "$(((get-date).ToUniversalTime()).ToString("yyyyMMddTHHmmssZ"))"
        $scriptname = "AuditInstalledSoftware2CSV"
        $file = "$scriptname-$computername-$timestamp.csv"
        $outputpath = "C:\temp\Scripts\$scriptname"
        $csvoutfile = "$outputpath\$file"
        If(!(test-path $outputpath)){
            New-Item -ItemType Directory -Force -Path $outputpath
        }
        Get-WmiObject -Namespace ROOT\CIMV2 -Class Win32_Product  | Select-Object Installdate, Name, Version, Vendor, PSComputerName | Sort-Object Installdate | Export-CSV $csvoutfile -NoTypeInfo
    }
    Copy-Item \\"$computer"\c$\temp\Scripts\AuditInstalledSoftware2CSV\*.csv $finaldestination
}

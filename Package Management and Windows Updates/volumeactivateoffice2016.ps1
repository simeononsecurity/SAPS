#Activate Office 2016 MAC and KMS Script

#Require elivation for script run
Requires -RunAsAdministrator

#Office Installation Paths
$office32="C:\Program Files (x86)\Microsoft Office\Office16"
$office64="C:\Program Files\Microsoft Office\Office16"

# GVLKs for KMS and Active Directory-based activation of Office 2019 and Office 2016
# https://docs.microsoft.com/en-us/deployoffice/vlactivation/gvlks
# XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99

If (Test-Path -Path $office32){
    Write-Output "Microsoft Office 32-Bit Is Installed"
    Write-Output "Setting Office General Activication License"
    cscript $office32\OSPP.VBS /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
    #Write-Output "Setting KMS Server"
    #cscript $office32\ospp.vbs /sethst:KMSServerName.contoso.com
    Write-Output "Activating Office"
    cscript $office32\OSPP.VBS /act
    Write-Output "Checking Activation Status"
    cscript $office32\ospp.vbs /dstatus
}Else {
    Write-Output "Microsoft Office 32-Bit Is Not Installed"
}
If (Test-Path -Path $office64){
    Write-Output "Microsoft Office 64-Bit Is Installed"
    Write-Output "Setting Office General Activication License"
    cscript $office64\OSPP.VBS /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99
    #Write-Output "Setting KMS Server"
    #cscript $office64\ospp.vbs /sethst:KMSServerName.contoso.com
    Write-Output "Activating Office"
    cscript $office64\OSPP.VBS /act
    Write-Output "Checking Activation Status"
    cscript $office64\ospp.vbs /dstatus
}Else {
    Write-Output "Microsoft Office 64-Bit Is Not Installed"
}
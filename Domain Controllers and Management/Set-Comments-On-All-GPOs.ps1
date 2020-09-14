#https://github.com/simeononsecurity/SAPS
#Use this script to set a specific comment on all GPOs in your domain. 
#Must be run with an OU admin or higher admin account
#You must change the value for the "Comment" variable below.

#Script Variables
$GPOLISTGEN = Get-GPO -ALL  
$Comment = "Change Me"

#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
#Requires -RunAsAdministrator
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)



Foreach ($GPO in ($GPOLISTGEN.DisplayName)){(get-gpo -Name "$GPO").Description = "$Comment"}

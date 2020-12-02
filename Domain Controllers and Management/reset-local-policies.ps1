#Require elivation for script run
#Requires -RunAsAdministrator

cmd /C 'RD /S /Q "%WinDir%\System32\GroupPolicy"'
cmd /C 'RD /S /Q "%WinDir%\System32\GroupPolicyUsers"'
cmd /C "secedit /configure /cfg %windir%\inf\defltbase.inf /db defltbase.sdb /verbose"
gpupdate /force /boot

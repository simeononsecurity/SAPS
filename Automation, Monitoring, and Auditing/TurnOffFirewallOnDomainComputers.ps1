Foreach ($COMPUTER in $(Get-ADComputer -Filter *)){
  write-host "Connecting to $($COMPUTER.Name)"
  NetSh Advfirewall set allprofiles state off
}


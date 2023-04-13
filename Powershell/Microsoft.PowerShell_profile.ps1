$env:path += ";$home\Documents\GitHub\COMP2101\PowerShell" 
new-item -path alias:np -value notepad | out-null

# Lab 2 COMP2101 welcome script for profile
#

write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
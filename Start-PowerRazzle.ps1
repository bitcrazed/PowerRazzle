write-host -NoNewline '  Starting ...'
#Configure GIT colors for this session:
$global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow 
$global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Cyan

write-host ' PowerRazzle is now at your command!'
write-host '######################################################################'
write-host ''

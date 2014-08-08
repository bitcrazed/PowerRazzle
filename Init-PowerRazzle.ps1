$git = "${env:ProgramFiles(x86)}\git\bin\git.exe"

# Configure Git:
& $git config --global user.email "rich@bitcrazed.com"
& $git config --global user.name "Rich Turner"

# Configure BeyondCompare as the default diff and merge tool:
& $git config --global diff.tool bc4
& $git config --global difftool.bc4.path "${env:ProgramFiles(x86)}\beyond compare 4\bcomp.exe"
& $git config --global merge.tool bc4
& $git config --global mergetool.bc4.path "${env:ProgramFiles(x86)}\beyond compare 4\bcomp.exe"

# Configure Powershell-friendly colors:
& $git config --global color.status.changed "yellow normal bold" 
& $git config --global color.status.untracked "cyan normal bold"
& $git config --global color.status.added "green normal bold"

$global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow 
$global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Cyan

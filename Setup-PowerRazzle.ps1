$git = "${env:ProgramFiles(x86)}\git\bin\git.exe"

if ($git) {
    echo 'Configuring GIT'
    echo '  Configuring User'
    & $git config --global user.email "rich@bitcrazed.com"
    & $git config --global user.name "Rich Turner"

    echo '  Configuring PowerShell-friendly colors'
    & $git config --global color.status.changed "yellow normal bold" 
    & $git config --global color.status.untracked "cyan normal bold"
    & $git config --global color.status.added "green normal bold"

    $global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow 
    $global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Cyan

    echo '  Configuring BeyondCompare as diff & merge tool'
    & $git config --global difftool.prompt false
    & $git config --global diff.tool bc3
    & $git config --global difftool.bc3.path "${env:ProgramFiles(x86)}\Beyond Compare 4\BComp.exe"
    #& $git config --global mergetool.prompt false
    & $git config --global merge.tool bc3
    & $git config --global mergetool.bc3.path "${env:ProgramFiles(x86)}\Beyond Compare 4\BComp.exe"

    echo 'Done!'
}
else {
    echo "Uh oh! GIT is not installed!"
}
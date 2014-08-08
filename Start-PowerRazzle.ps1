# PowerRazzle Developer Environment
# Copyright 2011-2013, Richard Turner (rich@bitcrazed.com)
# Master Source: https://github.com/bitcrazed/PowerRazzle
# Creative Commons Attribution: Non-Commercial Share Alike (CC BY-NC-SA)
$powerRazzleVersion = '1.0.5'

#--- Initialise PowerRazzle environment:
write-output '######################################################################'
write-output "  PowerRazzle Developer Console (Version: $powerRazzleVersion)"
write-output '  Fork me on GitHub: https://github.com/bitcrazed/PowerRazzle'
write-output '----------------------------------------------------------------------'
pushd

# Global functions:
function global:Up([int] $numlevels)
{
    for ($i = 0; $i -lt $numlevels; $i++)
    {
        cd ..
    }
}

# Add a folder to the path (if it's not already in the path)
function add-path([string] $folder, [bool] $quiet = $false)
{
    if (($env:Path -split ';' | where {$_ -eq $folder }).Count -eq 0)
    {
        if ($env:path[$env:path.length - 1] -ne ';') { $env:path += ';' }
        $env:path += $folder
        if (!$quiet) { write-output "  + Added '$folder' to the path" }
    }
}

# In case we're called from somewhere other than $profile, find the dev root folder:
if (!$env:DevRoot)
{
    if (test-path 'c:\dev\') { $env:DevRoot = 'c:\dev\' }
    elseif (test-path 'd:\dev\') { $env:DevRoot = 'd:\dev\' }
    else { throw 'Cannot find dev path' }
}

# Add Git to the path (just in case it wasn't already!)
add-path "${env:ProgramFiles(x86)}\Git\Bin"
write-output "  Using $(git --version)"

# Add/Remove/Modify the following aliases to your needs
set-alias grep 'select-string' -scope global
set-alias whereis "$env:SystemRoot\System32\where.exe" -scope global
set-alias subl "${env:ProgramW6432}\Sublime Text 3\sublime_text.exe" -scope global
set-alias d "${env:ProgramFiles(x86)}\Beyond Compare 3\BComp.com" -scope global
set-alias wpi "${env:ProgramW6432}\Microsoft\Web Platform Installer\WebPiCmd.exe" -scope global

# Alias FFMPEG if present:
$ffmpeg = ls \tools\ffmpeg-* | sort {$_.Name} -Descending | select -First 1 -Property Name
if ($ffmpeg) { 
    set-alias ffmpeg "c:\tools\$($ffmpeg.Name)\bin\ffmpeg.exe" -scope global
}

#Configure GIT colors for this session:
$global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow 
$global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Cyan

cd $env:DevRoot

write-output '----------------------------------------------------------------------'
write-output '  PowerRazzle is now at your command!'
write-output '######################################################################'
write-output ''

# PowerRazzle Developer Environment
# Copyright 2011-2013, Richard Turner (rich@bitcrazed.com)
# Master Source: https://github.com/bitcrazed/PowerRazzle
# Creative Commons Attribution: Non-Commercial Share Alike (CC BY-NC-SA)
$powerRazzleVersion = '1.0.6'

#--- Initialise PowerRazzle environment:
write-host '######################################################################'
write-host "  PowerRazzle Developer Console (Version: $powerRazzleVersion)"
write-host '  Fork me on GitHub: https://github.com/bitcrazed/PowerRazzle'
write-host '  Initializing ...'
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
function global:Add-Path([string] $folder, [bool] $quiet = $false)
{
    if (($env:Path -split ';' | where {$_ -eq $folder }).Count -eq 0)
    {
        if ($env:path[$env:path.length - 1] -ne ';') { $env:path += ';' }
        $env:path += $folder
        if (!$quiet) { write-host "    + Added '$folder' to the path" }
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
write-host "    + Using $(git --version)"

# Add/Remove/Modify the following aliases to your needs
set-alias grep 'select-string' -scope global
set-alias whereis "$env:SystemRoot\System32\where.exe" -scope global
set-alias subl "${env:ProgramW6432}\Sublime Text 3\sublime_text.exe" -scope global
set-alias d "${env:ProgramFiles(x86)}\Beyond Compare 3\BComp.com" -scope global
set-alias wpi "${env:ProgramW6432}\Microsoft\Web Platform Installer\WebPiCmd.exe" -scope global
set-alias msbuild "${env:ProgramFiles(x86)}\MSBuild\12.0\bin\MSBuild.exe" -scope global

# Alias FFMPEG if present:
$ffmpeg = ls d:\tools\ffmpeg-* | sort {$_.Name} -Descending | select -First 1 -Property Name
if ($ffmpeg) { 
    set-alias ffmpeg "d:`\tools`\$($ffmpeg.Name)`\bin`\ffmpeg.exe" -scope global
}

cd $env:DevRoot

write-host '  Done'

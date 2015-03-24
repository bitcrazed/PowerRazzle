# PowerRazzle Developer Environment
# Copyright 2011-2015, Richard Turner (rich@bitcrazed.com)
# Master Source: https://github.com/bitcrazed/PowerRazzle
# Creative Commons Attribution: Non-Commercial Share Alike (CC BY-NC-SA)
$powerRazzleVersion = '1.0.8'

#--- Initialise PowerRazzle environment:
write-host '######################################################################'
write-host "  PowerRazzle Developer Console (Version: $powerRazzleVersion)"
write-host '  Fork me on GitHub: https://github.com/bitcrazed/PowerRazzle'
write-host '  Initializing ...'
pushd

# Global functions:
function global:Up([int] $numlevels)
{
    for ($i = 0; $i -lt $numlevels; $i++) { cd .. }
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

function global:Get-FolderSize([string] $p = '.\' )
{
    $objFSO = New-Object -com  Scripting.FileSystemObject
    $folders = (dir $p | ? {$_.PSIsContainer -eq $True})
    foreach ($folder in $folders)
    {
        $folder | Add-Member -MemberType NoteProperty -Name "SizeMB" -Value ('{0:f2} MB' -f (($objFSO.GetFolder($folder.FullName).Size) / 1MB)) -PassThru | select -Property FullName, SizeMB
    }
 
}

function global:Get-LatestPath([string] $root)
{
	ls $root | sort -Descending | select -First 1 | select -ExpandProperty FullName
}

# In case we're called from somewhere other than $profile, find the dev root folder:
if (!$env:DevRoot)
{
    if (test-path 'c:\dev\') { $env:DevRoot = 'c:\dev' }
    elseif (test-path 'd:\dev\') { $env:DevRoot = 'd:\dev' }
    else { throw 'Cannot find dev path' }
}

# Add Git to the path (just in case it wasn't already!)
add-path "${env:ProgramFiles(x86)}\Git\Bin"
write-host "    + Using $(git --version)"

# Ensure we have the latest Java on the path:
$java = Get-LatestPath 'C:\Program Files\Java\jdk*\' 
if ($java)
{
    $env:JAVA_HOME = "$java"
    add-path "$java\bin\"
}

# The following toolsets are needed on the path:
add-path "${env:ProgramFiles(x86)}\Microsoft SDKs\F#\4.0\Framework\v4.0\"
add-path "$env:DevRoot\tools\Maven\Bin"
add-path "$env:DevRoot\tools\activator"

# Add/Remove/Modify the following aliases to your needs
set-alias grep 'select-string' -scope global
set-alias whereis "$env:SystemRoot\System32\where.exe" -scope global

# Only need aliases for the following as they're the only tools (needed) in the target folder:
set-alias d "${env:ProgramFiles(x86)}\Beyond Compare 3\BComp.com" -scope global
set-alias subl "${env:ProgramW6432}\Sublime Text 3\sublime_text.exe" -scope global
set-alias wpi "${env:ProgramW6432}\Microsoft\Web Platform Installer\WebPiCmd.exe" -scope global
set-alias msbuild "${env:ProgramFiles(x86)}\MSBuild\14.0\bin\MSBuild.exe" -scope global
set-alias vertx "$env:DevRoot\tools\vert.x-2.1.5\bin\vertx.bat" -scope global

cd $env:DevRoot

write-host '  Done'

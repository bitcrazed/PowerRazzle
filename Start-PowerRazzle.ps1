# PowerRazzle Developer Environment
# Copyright 2011-2012, Richard Turner (rich@bitcrazed.com)
# Creative Commons Attribution: Non-Commercial Share Alike (CC BY-NC-SA)

#--- Public Functions --- 
function global:up([int]$numlevels)
{
    for ($i = 0; $i -lt $numlevels; $i++)
    {
        cd ..
    }
}

function global:Find-Path($Path, [switch]$All=$false, [Microsoft.PowerShell.Commands.TestPathType]$type="Any")
{
## You could  comment out the function stuff and use it as a script instead, with this line:
# param($Path, [switch]$All=$false, [Microsoft.PowerShell.Commands.TestPathType]$type="Any")
    if($(Test-Path $Path -Type $type)) {
       return $path
    } else {
       [string[]]$paths = @($pwd); 
       $paths += "$pwd;$env:path".split(";")
       
       $paths = Join-Path $paths $(Split-Path $Path -leaf) | ? { Test-Path $_ -Type $type }
       if($paths.Length -gt 0) {
          if($All) {
             return $paths;
          } else {
             return $paths[0]
          }
       }
    }
    throw "Couldn't find a matching path of type $type"
}

function global:add-path([string] $folder, [bool] $quiet = $false)
{
    if (($env:Path -split ';' | where {$_ -eq $folder }).Count -eq 0)
    {
        $env:path += ';' + $folder
        if (!$quiet) { write-output "Added '$folder' to the path" }
    }
}

function exec-cmdscript([string] $script, [string] $parameters)
{
    $tempFile = [IO.Path]::GetTempFileName()

    ## Store the output of cmd.exe.  We also ask cmd.exe to output
    ## the environment table after the batch file completes
    cmd /c " `"$script`" $parameters && set > `"$tempFile`" "

    ## Go through the environment variables in the temp file.
    ## For each of them, set the variable in our local environment.
    Get-Content $tempFile | Foreach-Object {
        if($_ -match "^(.*?)=(.*)$")
        {
            Set-Content "env:\$($matches[1])" $matches[2]
        }
    }

    Remove-Item $tempFile
}

#--- Initialise PowerRazzle environment:
write-output '######################################################################'
write-output '                  PowerRazzle Developer Console'
write-output '----------------------------------------------------------------------'
pushd

# In case we're called from somewhere other than $profile, find the dev root folder:
if (!$env:DevRoot)
{
    if (test-path 'c:\dev\') { $env:DevRoot = 'c:\dev\' }
    elseif (test-path 'd:\dev\') { $env:DevRoot = 'd:\dev\' }
    else { throw 'Cannot find dev path' }
}

add-path "${env:ProgramFiles(x86)}\Git\Bin"
write-output "Using $(git --version)"

write-output "Configuring aliases" 
set-alias subl "${env:ProgramW6432}\Sublime Text 2\sublime_text.exe" -scope global
set-alias grep 'select-string' -scope global
set-alias d "${env:ProgramFiles(x86)}\Beyond Compare 3\BComp.com" -scope global
set-alias wpi "${env:ProgramW6432}\Microsoft\Web Platform Installer\WebPiCmd.exe" -scope global
set-alias xc "xunit.console.clr4" -scope global
set-alias whereis "$env:SystemRoot\System32\where.exe" -scope global
set-alias make "$env:DevRoot\Tools\GNU\make-3.82\Debug\make.exe" -scope global

write-output "Currently Active PowerShell Modules:"
get-module -All | % { "  $_" }

write-output '----------------------------------------------------------------------'
write-output "                PowerRazzle is now at your command!"
write-output '######################################################################'
write-output ''
popd

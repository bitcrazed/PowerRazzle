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

#--- Private Functions ---
function add-path([string] $folder, [bool] $quiet = $false)
{
    $paths = $env:Path -split ';'
    if (!$paths.Contains($folder))
    {
        if ($quiet -ne $true) { write-output "    '$folder' added" }
        $paths += $folder
        $newPath = $paths -join ';'
        $env:path = $newPath
        if (!$quiet) { write-output "    '$folder' added" }
    }
    else
    {
        if (!$quiet) { write-warning "Folder '$folder' already exists in the path ($quiet) - skipping" }
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
write-output ''
write-output '--- Power Razzle Developer Console ---'
pushd

# In case we're called from somewhere other than $profile, find the dev root folder:
if (!$env:DevRoot)
{
    if (test-path 'd:\dev\') { $env:DevRoot = 'd:\dev\' }
    elseif (test-path 'c:\dev\') { $env:DevRoot = 'c:\dev\' }
    else { throw 'Cannot find dev path' }
}

write-output 'Installing Developer Tools:'

### Install latest Visual Studio SDK if present:
if (test-path "${env:ProgramFiles(x86)}\Microsoft Visual Studio*") 
{
    Write-Progress -Activity 'Configuring environment' -Status 'Configuring Visual Studio environment variables' -PercentComplete 20
    
    $vsFolder = dir "${env:ProgramFiles(x86)}\Microsoft Visual Studio*" | 
        where {$_ -notlike '*SDK*' } | 
        sort {[System.Double]::Parse($_.Name.Replace('Microsoft Visual Studio ', ''))} -Descending | 
        select -First 1 -Unique -ExpandProperty Name
    $vsPath = "${env:ProgramFiles(x86)}\$vsFolder"
    
    exec-cmdscript "$vsPath\VC\vcvarsall.bat" x86

    write-output "    Configured $vsFolder environment"
}
else
{
    write-warning '    Could not locate Visual Studio!'
}

# Find the latest version of the Azure SDK:
$azureSdkPath = "$env:ProgramW6432\Windows Azure SDK"
if (test-path $azureSdkPath) 
{
    Write-Progress -Activity "Configuring environment" -Status "Configuring Azure Development environment variables" -PercentComplete 30
    $azureVersion = dir $azureSdkPath | sort -Descending | Select -First 1 -Unique
    exec-cmdscript "$azureSdkPath\$azureVersion\bin\setenv.cmd" | out-null
	write-output "    Using Azure SDK version $azureVersion"
}
else
{
	write-warning '    No Azure SDK Installed!'
}

write-output "Updating the path"
Write-Progress -Activity "Configuring environment" -Status "Updating Path" -PercentComplete 50
add-path "${env:ProgramFiles}\Git\Bin"

write-output "Configuring aliases" 
Write-Progress -Activity "Configuring environment" -Status "Declaring Aliases" -PercentComplete 70
set-alias sub "${env:ProgramW6432}\Sublime Text 2\sublime_text.exe" -scope global
set-alias subl "${env:ProgramW6432}\Sublime Text 2\sublime_text.exe" -scope global
set-alias grep 'select-string' -scope global
set-alias d "${env:ProgramFiles}\Beyond Compare 3\BComp.com" -scope global

$Host.UI.RawUI.WindowTitle = "PowerRazzle"
cd "$($env:DevRoot)Tools"
write-output ''
write-output '--- PowerRazzle is now at your command ---'
write-output ''

popd

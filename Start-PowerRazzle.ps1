# PowerRazzle Developer Environment
# Copyright 2011-2012, Richard Turner (rich@bitcrazed.com)
# Creative Commons Attribution: Non-Commercial Share Alike (CC BY-NC-SA)

#--- Functions --- 
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

if (test-path 'd:\dev\') { $env:DevRoot = 'd:\dev\' }
elseif (test-path 'c:\dev\') { $env:DevRoot = 'c:\dev\' }
else { throw 'Cannot find dev path' }

cd $env:DevRoot
cd tools

write-output 'Installing Developer Tools:'

### Install latest Visual Studio SDK if present:
if (test-path "${env:ProgramFiles(x86)}\Microsoft Visual Studio*") 
{
    Write-Progress -Activity 'Configuring environment' -Status 'Configuring Visual Studio environment variables' -PercentComplete 40
    
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

### Install Azure Node SDK if present:
$nodeSdkRoot = "$env:ProgramFiles\Microsoft SDKs\Windows Azure\Nodejs\"
if (test-path "$nodeSdkRoot\Nov2011\PowerShell\") {
    pushd
    cd "$nodeSdkRoot"
    Get-ChildItem "Nov2011\PowerShell\*cmdlets.dll" | 
        ForEach-Object {Import-Module $_}
    popd

    ### Add Node to the path:
    $env:path += ";${env:ProgramFiles(x86)}\nodeJS"
    write-output '    Installed Azure Node SDK'
}
else {
    write-warning '    No Azure Node SDK Installed!'
}

function global:add-path($folder, $quiet = $false)
{
    $paths = $env:Path -split ';'
    if (!$paths.Contains($folder))
    {
        if ($quiet -ne $true) { write-output "    '$folder' added" }
        $paths += $folder
        $newPath = $paths -join ';'
        $env:path = $newPath
    }
    else
    {
        if ($quiet -ne $true) { write-warning "Folder '$folder' already exists in the path ($quiet)" }
    }
}

function global:up ($numlevels)
{
    for ($i = 0; $i -lt $numlevels; $i++)
    {
        cd ..
    }
}

write-output "Adding folders to the path:"
add-path("${env:ProgramFiles}\Git\Bin")

write-output "Configuring aliases" 
set-alias sub "${env:ProgramW6432}\Sublime Text 2\sublime_text.exe" -scope global
set-alias subl "${env:ProgramW6432}\Sublime Text 2\sublime_text.exe" -scope global
set-alias grep 'select-string' -scope global
set-alias d "${env:ProgramFiles}\Beyond Compare 3\BComp.com" -scope global

$Host.UI.RawUI.WindowTitle = "PowerRazzle"
write-output ''

popd

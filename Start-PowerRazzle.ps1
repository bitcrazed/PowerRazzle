# PowerRazzle Commnand-Line Environment
# Copyright 2011-2015, Richard Turner (rich@bitcrazed.com)
# Master Source: https://github.com/bitcrazed/PowerRazzle
# Creative Commons Attribution: Non-Commercial Share Alike (CC BY-NC-SA)
$powerRazzleVersion = '1.1'

# Initialise PowerRazzle environment:
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 0 
Write-Host "PowerRazzle Developer Environment (Version: $powerRazzleVersion)"

# Functions
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 10 -Status 'Declaring Functions'

function Add-Path($newFolderPath)
{
    Write-Progress -Activity 'Starting PowerRazzle' -Status "Adding '$newFolderPath' to the Path"
    
    if ($newFolderPath -ne '' -and $env:Path.IndexOf($newFolderPath) -eq -1) { 
        Write-Progress -Activity 'Starting PowerRazzle' -Status "Added '$newFolderPath' to the Path"
        $env:Path += ";$newFolderPath" 
    }
    else {
        Write-Progress -Activity 'Starting PowerRazzle' -Status "Skipping '$newFolderPath' - already on the Path"        
    }
}

function global:Up([int] $numlevels = 1)
{
    for ($i = 0; $i -lt $numlevels; $i++) { Set-Location .. }
}

# Evnrionment
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 40 -Status 'Configuring Environment'
# Add the $scriptRoot to the path as there will be utility scripts in this folder.
Add-Path($PSScriptRoot)

# Aliases
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 70 -Status 'Configuring Aliases'
Set-Alias grep 'select-string' -scope global
Set-Alias whereis "$env:SystemRoot\System32\where.exe" -scope global

# Cleanup
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 100
Write-Host ''
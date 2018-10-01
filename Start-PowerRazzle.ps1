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

function global:Up
{
    param(
        [Parameter(Mandatory = $false)]
        [int] $numlevels = 1
    )

    for ($i = 0; $i -lt $numlevels; $i++)
    {
        Set-Location ..
    }
}


function global:Mark-Text
{
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      [string] $InputObject,

      [Parameter(Mandatory = $true, Position = 0)]
      [string] $Regex,

      [Parameter(Mandatory = $false, Position = 1)]
      [ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray | DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
      [string] $HighlightColor = 'Yellow',

      [Parameter(Mandatory = $false, Position = 2)]
      [ValidateSet('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta', 'DarkYellow', 'Gray | DarkGray', 'Blue', 'Green', 'Cyan', 'Red', 'Magenta', 'Yellow', 'White')]
      [string] $TextColor = 'Black'
   )
   begin
   {
       $r = [regex]$Regex
    }
   process
   {
       $matches = $r.Matches($inputObject)
       $startIndex = 0

       foreach($match in $matches)
       {
          $noMatchLength = $match.Index - $startIndex
          Write-Host $inputObject.Substring($startIndex, $noMatchLength) -NoNewline
          Write-Host $match.Value -BackgroundColor $HighlightColor -ForegroundColor $TextColor -NoNewline
          $startIndex = $match.Index + $match.Length
       }

       if($startIndex -lt $inputObject.Length)
       {
          Write-Host $inputObject.Substring($startIndex) -NoNewline
       }

       Write-Host
   }
}

# Aliases
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 70 -Status 'Configuring Aliases'
Set-Alias grep 'select-string' -scope global
Set-Alias whereis "$env:SystemRoot\System32\where.exe" -scope global

# Evnrionment
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 40 -Status 'Configuring Environment'
# Add the $scriptRoot to the path as there will be utility scripts in this folder.
Add-Path($PSScriptRoot)

# Cleanup
Write-Progress -Activity 'Starting PowerRazzle' -PercentComplete 100
Write-Host ''
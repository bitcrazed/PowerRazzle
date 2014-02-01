function Find-Path($Path, [switch]$All=$false, [Microsoft.PowerShell.Commands.TestPathType]$type="Any")
{
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

# Configure Powershell-friendly colors:
git config --global color.status.changed "yellow normal bold" 
git config --global color.status.untracked "cyan normal bold"
git config --global color.status.added "green normal bold"

$global:GitPromptSettings.WorkingForegroundColor    = [ConsoleColor]::Yellow 
$global:GitPromptSettings.UntrackedForegroundColor  = [ConsoleColor]::Cyan

# Install Chocolatey if necessary:
try {
    find-path "chocolatey.bat"
}
catch {
    iex ((new-object net.webclient).DownloadString('http://chocolatey.org/install.ps1'))
    $env:Path="$env:Path;$env:systemdrive\chocolatey\bin"
}

#Install Chocolatey packages:
cinst packages.config

function Find-Path($Path, [switch]$All=$false, [Microsoft.PowerShell.Commands.TestPathType]$type="Any")
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

# Check if NPM is on the path. If not, ask the user to re-run.
try {
    find-path "node.exe"

    # Check if NPM is on the path. If not, ask the user to re-run.
    try {
        find-path "npm.cmd"

        # Install NPM global packages (defined in packages.json):
        npm install -global
    }
    catch {
        write-error 'Please re-run Install-PowerRazzle to continue installing components (npm)'
    }
}
catch {
    # Install node.js and npm
    cinst nodejs.install
    write-error 'Please re-run Install-PowerRazzle to continue installing missing components (node)'
}


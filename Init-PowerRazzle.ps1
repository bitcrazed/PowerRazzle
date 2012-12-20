# Install Chocolatey if necessary:
C:\Windows\System32\where.exe node.exe
if ($LASTEXITCODE -ne 0)
{
    iex ((new-object net.webclient).DownloadString('http://chocolatey.org/install.ps1'))
    $env:Path="$env:Path;$env:systemdrive\chocolatey\bin"
}

#Install Chocolatey packages:
cinst git
cinst githubforwindows
cinst 7zip
cinst 7zip.commandline
cinst poshgit

# Check if NPM is on the path. If not, ask the user to re-run.
C:\Windows\System32\where.exe node.exe
if ($LASTEXITCODE -ne 0)
{
    # Install node.js and npm
    cinst nodejs.install
    write-error 'Please re-run Install-PowerRazzle to continue installing missing components (node)'
}
else {

    # Check if NPM is on the path. If not, ask the user to re-run.
    C:\Windows\System32\where.exe npm.com
    if ($LASTEXITCODE -ne 0)
    {
        write-error 'Please re-run Install-PowerRazzle to continue installing components (npm)'
    }
    else {
        # Install NPM global packages:
        npm install typescript -Global
        npm install coffee-script -Global
        npm install azure -Global
    }
}
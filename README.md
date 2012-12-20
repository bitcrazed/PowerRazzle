PowerRazzle
===========
My preferred PowerShell-based development environment into which all the tools I need are hooked-in, aliased, etc.

Installation
------------
Clone this repo to your favorite development tools root. I prefer X:\Dev\Tools (where X is the name of the drive on which my dev projects are stored).

I suggest adding the following to your $profile:

```
# Set the 'DevRoot' environment variable to point to the development root folder:
if (test-path 'd:\dev\') { $env:DevRoot = 'd:\dev\' }
elseif (test-path 'c:\dev\') { $env:DevRoot = 'c:\dev\' }
else { throw 'Cannot find dev path' }

# Start the PowerRazzle environment initializer:
& $env:DevRoot\Tools\PowerRazzle\Start-PowerRazzle.ps1
```

Usage
-----
Open PowerShell and you should see something similar to the following welcome banner:

```
Windows PowerShell
Copyright (C) 2012 Microsoft Corporation. All rights reserved.


--- Power Razzle Developer Console ---
Installing Developer Tools:
    Configured Microsoft Visual Studio 11.0 environment
    Using Azure SDK version v1.6
Updating the path
    'C:\Program Files (x86)\Git\Bin' added
Configuring aliases

--- PowerRazzle is now at your command ---

D:\dev>
```

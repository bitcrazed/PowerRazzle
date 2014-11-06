$backupPath = "d:\backup\user\$env:username\"
if (!(test-path $backupPath)) { 
    mkdir "$backupPath" 
}

echo 'Backing-up folders:'

'.android',
'.atom',
'.config',
'.ssh' | 
    % { 
        $source = "~\$_"
        $dest = "$backupPath$_\"
        echo "    Copying `"$source`" to `"$dest`""
        copy -force -recurse $source $dest
    }

echo ''
echo 'Backing-up files:'

'.gitconfig' |
    % { 
        $source = "~\$_"
        $dest = "$backupPath$_"
        echo "    Copying `"$source`" to `"$dest`""
        copy -force $source $dest
    }

echo 'Backing-up PowerShell Profile:'
'Documents\WindowsPowerShell' |
    % { 
        $source = "$env:userprofile\$_\*.*"
        $dest = "$backupPath$_\"
        
        if (!(test-path $dest)) { 
            echo "    Creating path for `"$dest`":"
            mkdir -force $dest  | out-null
        }

        echo "    Copying `"$source`" to `"$dest`":"
        copy $source $dest
    }

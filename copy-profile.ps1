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

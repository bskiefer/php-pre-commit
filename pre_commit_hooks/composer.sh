#!/bin/bash

# Bash Composer Normalizer [DRY]
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
# - https://github.com/localheinz/composer-normalize
#
# Arguments
#  --dry-run
#  --no-update-lock

# Echo Colors
msg_color_magenta='\e[1;35m'
msg_color_yellow='\e[0;33m'
msg_color_none='\e[0m' # No Color

# Loop through the list of paths
echo -en "${msg_color_yellow}Begin Composer Normalize ...${msg_color_none} \n"

composer_local_exec="composer.phar"
composer_command="php $composer_local_exec"

# Check vendor/bin/composer
composer_vendor_command="vendor/bin/composer"
composer_global_command="composer"
if [ -f "$composer_vendor_command" ]; then
    composer_command=$composer_vendor_command
else
    if hash composer 2>/dev/null; then
        composer_command=$composer_global_command
    else
        if [ -f "$composer_local_exec" ]; then
            composer_command=$composer_command
        else
            echo "No valid Composer executable found! Please have one available as either $composer_vendor_command, $composer_global_command or $composer_local_exec"
            exit 1
        fi
    fi
fi

composer_command="$composer_command normalize $*"

echo "Running command $composer_command"
command_result=`eval $composer_command`

# Errors found
if [ $? -ne 0 ]; then

    echo "Failures detected during composer normalize..."
    echo "$command_result"
    exit 1
    
fi

exit 0
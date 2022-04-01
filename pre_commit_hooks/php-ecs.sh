#!/bin/bash

# Bash PHP ECS Hook
# This script fails if the PHP ECS output has the word "ERROR" in it.
# Does not support failing on WARNING AND ERROR at the same time.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - php
#
# Arguments
# - None

# Echo Colors
msg_color_magenta='\033[1;35m'
msg_color_yellow='\033[0;33m'
msg_color_none='\033[0m' # No Color

# Loop through the list of paths to run php ECS against
echo -en "${msg_color_yellow}Begin PHP ECS ...${msg_color_none} \n"
ecs_local_exec="ecs.phar"
ecs_command="php $ecs_local_exec"

# Check vendor/bin/phpunit
ecs_vendor_command="vendor/bin/ecs"
ecs_global_command="ecs"
if [ -f "$ecs_vendor_command" ]; then
	ecs_command=$ecs_vendor_command
else
    if hash ecs 2>/dev/null; then
        ecs_command=$ecs_global_command
    else
        if [ -f "$ecs_local_exec" ]; then
            ecs_command=$ecs_command
        else
            echo "No valid PHP ECS executable found! Please have one available as either $ecs_vendor_command, $ecs_global_command or $ecs_local_exec"
            exit 1
        fi
    fi
fi

ecs_files_to_check="${@:2}"
ecs_args=$1
ecs_command="$ecs_command $ecs_args $ecs_files_to_check"

echo "Running command $ecs_command"
command_result=`eval $ecs_command`
if [[ $command_result =~ ERROR ]]
then
    echo -en "${msg_color_magenta}Errors detected by PHP ECS ... ${msg_color_none} \n"
    echo "$command_result"
    exit 1
fi
echo "$command_result"
exit 0
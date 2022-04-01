#!/bin/bash

# Bash PHP blade Hook
# This script fails if the PHP blade output has the word "ERROR" in it.
# Does not support failing on WARNING AND ERROR at the same time.
#
# Exit 0 if no errors found
# Exit 1 if errors were found
#
# Requires
# - blade-formatter
#
# Arguments
# --write
# --diff
# --check-formatted

# Echo Colors
msg_color_magenta='\033[1;35m'
msg_color_yellow='\033[0;33m'
msg_color_blue='\033[0;34m'
msg_color_none='\033[0m' # No Color

# Loop through the list of paths to run php blade against
echo -en "${msg_color_yellow}Begin Blade Formatter ...${msg_color_none} \n"

blade_global_command=$(which blade-formatter)

echo "${blade_global_command}"

if test -z "$blade_global_command"; then
    echo -en "No valid PHP blade executable found!\n\t${msg_color_blue}npm install -g blade-formatter\n"
    exit 1
else
    blade_command=$blade_global_command
fi

blade_files_to_check="${@:2}"
blade_args=$1
blade_command="$blade_command $blade_args $blade_files_to_check"

echo "Running command $blade_command"
command_result=`eval $blade_command`
if [[ $command_result =~ ERROR ]]
then
    echo -en "${msg_color_magenta}Errors detected by Blade Formatter ... ${msg_color_none} \n"
    echo "$command_result"
    exit 1
fi
echo "$command_result"
exit 0
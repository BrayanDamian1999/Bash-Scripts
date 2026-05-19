#!/bin/bash
# This script creates a new Bash script file with a basic template.
# It checks if a filename is provided, appends ".sh" if no extension is given,
# writes a minimal script header, and makes the file executable. 
#
# AUTHOR:
# Brayan Noel Espinosa Damián
set -euo pipefail

name=$1

if [ -z "$name" ]; then
    echo "-- Error. Need a name for the script."
    exit 1
fi

if [[ ! "$name" == *.* ]]; then
    echo "-- Warning: No extension provided. .sh appended"
    name="${name}.sh"
fi

cat <<EOF > "$name"
#!/usr/bin/env bash

# Write your script here ...

EOF

chmod 700 "$name"
echo "-- Script '$name' created and made executable."
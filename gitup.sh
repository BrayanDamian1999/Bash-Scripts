#!/bin/bash

# ------------------------------------------------------------------------------
# This script automates a basic Git workflow.
# It performs the following steps:
#   1. Displays the current repository status (short format).
#   2. Waits 8 seconds so the user can review the status output.
#   3. Adds all modified files to the staging area.
#   4. Creates a commit with the provided message;
#      if no message is given, it uses the current date/time with "No message".
#   5. Waits 5 seconds so the user can review the status output.
#   6. Pushes the changes to the remote repository.
#
# Usage:
#   ./script.sh "Commit message"
#   ./script.sh             # If no message is provided, it uses date/time.
#   alias gitup='bash /path/of/the/script/gitup.sh'
#   gitup "Commit message"
# ------------------------------------------------------------------------------

set -euo pipefail

print_step() {
  echo
  echo ">> $1"
  echo
}

if [[ $# -ge 1 ]]; then
  commit_msg="$*"
else
  commit_msg="$(date '+%Y-%m-%d %H:%M:%S') - No message"
fi

print_step "git status"
git status -s
sleep 8

print_step "git add ."
git add .

print_step "git commit with the message: \"$commit_msg\""
sleep 5
git commit -m "$commit_msg"

print_step "git push"
git push

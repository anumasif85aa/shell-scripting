#!/bin/bash

# bash script.sh starts Bash explicitly.
# ./script.sh uses the shebang and requires execute permission.

pwd >/dev/null
success_status=$?

cd /this-directory-does-not-exist 2>/dev/null
failure_status=$?

echo "Successful command status: $success_status"
echo "Failing command status: $failure_status"


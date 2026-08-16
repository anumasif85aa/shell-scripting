#!/bin/bash

# Another command replaces $?, so each status is saved immediately.

pwd >/dev/null
pwd_status=$?

cd /directory-that-does-not-exist 2>/dev/null
cd_status=$?

echo "pwd status: $pwd_status"
echo "failing cd status: $cd_status"


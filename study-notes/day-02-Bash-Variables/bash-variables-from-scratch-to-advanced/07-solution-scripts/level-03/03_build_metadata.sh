#!/bin/bash

app_name="${1:-demo-app}"
build_number="${BUILD_NUMBER:-local}"
build_user="$(whoami)"
build_host="$(hostname)"
build_time="$(date +%Y%m%d-%H%M%S)"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    commit_id="$(git rev-parse --short HEAD)"
else
    commit_id="not-a-git-repository"
fi

build_id="${app_name}-${build_number}-${build_time}"

echo "Application: $app_name"
echo "Build number: $build_number"
echo "Build user: $build_user"
echo "Build host: $build_host"
echo "Build time: $build_time"
echo "Commit: $commit_id"
echo "Build ID: $build_id"

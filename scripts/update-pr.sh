#!/bin/bash
set -e

pr="$1"

if ! [[ "$pr" =~ ^[0-9]{5}$ ]]; then
    echo "Invalid PR $pr"
fi

path="$HOME/git/openshift/console-$pr"
test -d "$path"
cd "$path"
gh pr checkout "$pr" --force

echo
echo "Build frontend..."
echo
cd frontend
yarn install
yarn dev-once
cd ..

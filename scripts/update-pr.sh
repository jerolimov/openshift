#!/bin/bash
set -e

pr="$1"

if ! [[ "$pr" =~ ^[0-9]{4,5}$ ]]; then
    echo "Invalid PR $pr"
    exit 1
fi

path="$HOME/git/openshift/console-$pr"
test -d "$path"
cd "$path"
gh pr --repo openshift/console checkout "$pr" --force

echo
echo "Build backend..."
echo
./build-backend.sh

echo
echo "Build frontend..."
echo
cd frontend
rm -rf node_modules
yarn install
yarn dev-once
cd ..

#!/bin/bash
set -e

pr="$1"

if ! [[ "$pr" =~ ^[0-9]{5}$ ]]; then
    echo "Invalid PR $pr"
fi

echo
echo "Clone repo..."
echo
path="$HOME/git/openshift/console-$pr"
git clone git@github.com:openshift/console.git "$path"
cd "$path"
gh pr checkout "$pr"

echo
echo "Build backend..."
echo
./build-backend.sh

echo
echo "Build frontend..."
echo
cd frontend
yarn install
yarn dev-once
cd ..

$HOME/git/jerolimov/openshift/scripts/start-pr.sh $pr

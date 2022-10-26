#!/bin/bash
set -e

pr="$1"
if ! [[ "$pr" =~ ^[0-9]{4,5}$ ]]; then
    echo "Invalid PR $pr"
    exit 1
fi

dir="$HOME/git/openshift/console-$pr"

echo
echo "Delete PR $pr folder $dir"
echo

rm -rf "$dir"

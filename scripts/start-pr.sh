#!/bin/bash
set -e

pr="$1"
if ! [[ "$pr" =~ ^[0-9]{5}$ ]]; then
    echo "Invalid PR $pr"
fi

dir="$HOME/git/openshift/console-$pr"
hostname=$(hostname)

echo
echo "Serve PR $pr from $dir on http://${hostname}:$pr..."
echo

export KUBECONFIG=$HOME/.crc/machines/crc/kubeconfig
oc login -u kubeadmin -p $(cat $HOME/.crc/machines/crc/kubeadmin-password) --server https://api.crc.testing:6443

cd "$dir"
source ./contrib/oc-environment.sh && \
    bin/bridge -listen "http://0.0.0.0:$pr" -user-settings-location configmap

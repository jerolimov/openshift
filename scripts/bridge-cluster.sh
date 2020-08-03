#!/bin/bash

mv -v ~/Downloads/kubeconfig         ~/kubernetes/cluster45.conf
mv -v ~/Downloads/kubeadmin-password ~/kubernetes/cluster45.password

set -e

export HELM_REPOSITORY_CONFIG="/tmp/repositories.yaml"
export KUBECONFIG=~/kubernetes/cluster45.conf

cd ~/git/openshift/console
oc login -u kubeadmin -p $(cat $HOME/kubernetes/cluster45.password)
source ./contrib/oc-environment.sh

# Ignore errors to switch folder back
set +e
~/git/openshift/console/bin/bridge
cd -

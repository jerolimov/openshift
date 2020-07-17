#!/bin/bash

set -e

export VERSION="4.5.1"

export HELM_REPOSITORY_CONFIG="/tmp/repositories.yaml"
export KUBECONFIG=~/.crc/machines/crc/kubeconfig

cd ~/git/openshift/console
crc start
oc login -u kubeadmin -p $(cat $HOME/.crc/cache/crc_libvirt_$VERSION/kubeadmin-password)
source ./contrib/oc-environment.sh

# Ignore errors to switch folder back
set +e
~/git/openshift/console/bin/bridge
cd -

#!/bin/bash

export VERSION="4.5.1"

export HELM_REPOSITORY_CONFIG="/tmp/repositories.yaml"
export KUBECONFIG=~/.crc/machines/crc/kubeconfig

oc login -u kubeadmin -p $(cat $HOME/.crc/cache/crc_libvirt_$VERSION/kubeadmin-password)

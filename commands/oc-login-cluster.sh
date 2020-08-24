#!/bin/bash

export VERSION="4.5.4"

export HELM_REPOSITORY_CONFIG="/tmp/repositories.yaml"
export KUBECONFIG=~/kubernetes/cluster45.conf

oc login -u kubeadmin -p $(cat $HOME/kubernetes/cluster45.password)

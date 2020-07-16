#!/bin/bash

export KUBECONFIG=~/.crc/machines/crc/kubeconfig

export NAMESPACE="christoph-test"

resources=""

# OpenShift deployment & build configs
resources="$resources deploymentconfigs.apps.openshift.io"

resources="$resources buildconfigs.build.openshift.io"
resources="$resources builds.build.openshift.io"

resources="$resources routes.route.openshift.io"

resources="$resources imagestreams.image.openshift.io"
resources="$resources imagestreamtags.image.openshift.io"
resources="$resources images.image.openshift.io"

# Tekton / Pipelines
resources="$resources pipelines.tekton.dev"
resources="$resources pipelineresources.tekton.dev"
resources="$resources pipelineruns.tekton.dev"

# Knative
# TODO

# General pods and deployments
resources="$resources deployments.apps"
resources="$resources replicasets.apps"
resources="$resources services"
resources="$resources pods"

for resource in $resources; do
    echo Cleanup $resource
    names=$(oc get -n "$NAMESPACE" "$resource" -o name)
    if [ -n "$names" ]; then
        echo "$names" | xargs oc -n "$NAMESPACE" delete
    fi
done

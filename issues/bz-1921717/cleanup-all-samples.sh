#!/bin/bash

set -e

resources=$(
    oc get deployments   -o name
    oc get buildconfigs  -o name
    oc get services      -o name
    oc get routes        -o name
    oc get imagestream   -o name
    oc get secrets       -o name
)

for resource in $resources; do
    if [[ "$resource" == *golang-sample* ]]; then
        #echo "Delete $resource"
        oc delete "$resource"
    else
        echo "Keep $resource"
    fi
done

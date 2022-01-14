#!/bin/bash

#set -e

start=1
n=100

namespace="loadtest-$n-deployments"

for i in $(seq $start $(expr $start + $n - 1)); do
    deployment="deployment-$i-of-$n"
    lastnumber=$(expr $i % 10)
    if [ $lastnumber -eq 0 ]; then lastnumber=10; fi
    group="app-group-$lastnumber"

    # echo "Add deployment-$i-of-$n to $group"
    oc label -n "$namespace" Deployment "$deployment" "app.kubernetes.io/part-of=$group"
done

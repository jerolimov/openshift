#!/bin/bash

#set -e

start=1
n=100

namespace="loadtest-$n-deployments"

oc new-project "$namespace"

for i in $(seq $start $(expr $start + $n - 1)); do
    kubectl -n "$namespace" create deployment "deployment-$i-of-$n" --image=jerolimov/nodeinfo
done

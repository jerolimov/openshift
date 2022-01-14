#!/bin/bash

#set -e

start=1
n=100

namespace="loadtest-$n-deployments"

for i in $(seq $start $(expr $start + $n - 1)); do
    kubectl -n "$namespace" delete deployment "deployment-$i-of-$n"
done

#oc delete project "$namespace"

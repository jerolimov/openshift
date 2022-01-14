#!/bin/bash

#set -e

start=1
n=100

namespace="loadtest-$n-deployments"

s2i="nodejs/14-ubi8"
repo="https://github.com/jerolimov/nodeinfo"

oc new-project "$namespace"

for i in $(seq $start $(expr $start + $n - 1)); do
    oc new-app -n "$namespace" "$repo" --name "app-$i-of-$n"
done

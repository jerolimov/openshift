#!/bin/bash

#set -e

start=1
n=10

namespace="loadtest-$n-pods"

function pod {
    cat <<EOF
apiVersion: v1
kind: Pod
metadata:
  namespace: $namespace
  name: $1
spec:
  containers:
  - name: nodeinfo
    image: jerolimov/nodeinfo
EOF
}

function create {
    pipe_input=$(cat)
    #echo $*
    echo "$pipe_input" | oc create -f -
    #echo
}

oc new-project "$namespace"

for i in $(seq $start $(expr $start + $n)); do
    pod "pod-$i-of-$n" | create
done

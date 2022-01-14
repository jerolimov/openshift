#!/bin/bash

n=100

namespace="loadtest-$n-deployments"

kubectl get secrets -n "$namespace" -o name | \
    grep "of-$n" | \
    xargs kubectl delete -n "$namespace"

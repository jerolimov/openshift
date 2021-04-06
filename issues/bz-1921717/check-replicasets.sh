#!/bin/bash

set -e

for SUFFIX in {1..1000}; do
  d=$(date +"%H:%M:%S")
  c=$(oc get replicasets | grep golang-sample | wc -l)
  echo $d $c
  sleep 5
done

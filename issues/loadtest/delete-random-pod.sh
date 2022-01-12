#!/bin/bash

#set -e

namespace="loadtest-100-deployments"
delay_start=3
delay_each_time=2

echo
echo "Delete a random pod every $delay_each_time second from namespace $namespace"
echo

for i in $(seq $delay_start -1 1); do
    sleep 1
    echo $i
done

echo

while true; do
    random_podname=$(oc get -n "$namespace" --no-headers=true pods -o name | shuf | head -n 1)
    #echo "Delete pod $random_podname"
    oc delete -n "$namespace" "$random_podname"
    sleep $delay_each_time
done

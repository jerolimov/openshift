#!/bin/bash

set -e

# Random base64 string without a new lines to put it into the json below
bytes=200
random_base64_1=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_2=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_3=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_4=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_5=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_6=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_7=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_8=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_9=$(openssl rand -base64 $bytes | tr -d '\n')
random_base64_10=$(openssl rand -base64 $bytes | tr -d '\n')

# Ignore errors below
set +e

start=1
n=100

namespace="loadtest-$n-deployments"

oc new-project "$namespace"

function configmapWithoutData {
cat <<EOF
    {
        "apiVersion": "v1",
        "kind": "ConfigMap",
        "metadata": {
            "namespace": "$namespace",
            "name": "configmap-$i-of-$n-withoutdata"
        }
    }
EOF
}

function configmapWithRandomBase64Data {
cat <<EOF
    {
        "apiVersion": "v1",
        "kind": "ConfigMap",
        "metadata": {
            "namespace": "$namespace",
            "name": "configmap-$i-of-$n-withrandombase64data"
        },
        "data": {
            "key1": "$random_base64_1",
            "key2": "$random_base64_2",
            "key3": "$random_base64_3",
            "key4": "$random_base64_4",
            "key5": "$random_base64_5",
            "key6": "$random_base64_6",
            "key7": "$random_base64_7",
            "key8": "$random_base64_8",
            "key9": "$random_base64_9",
            "key10": "$random_base64_10"
        }
    }
EOF
}

for i in $(seq $start $(expr $start + $n - 1)); do
    configmapWithoutData | oc create -f -
    configmapWithRandomBase64Data | oc create -f -
done

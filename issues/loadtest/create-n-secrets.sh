#!/bin/bash

set -e

# Random base64 string without a new lines to put it into the json below
bytes=10000
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

function secretWithoutData {
cat <<EOF
    {
        "apiVersion": "v1",
        "kind": "Secret",
        "metadata": {
            "namespace": "$namespace",
            "name": "secret-$i-of-$n-withoutdata"
        },
        "type": "Opaque"
    }
EOF
}

function secretWithRandomBase64Data {
cat <<EOF
    {
        "apiVersion": "v1",
        "kind": "Secret",
        "metadata": {
            "namespace": "$namespace",
            "name": "secret-$i-of-$n-withrandombase64data"
        },
        "type": "Opaque",
        "stringData": {
            "secret1": "$random_base64_1",
            "secret2": "$random_base64_2",
            "secret3": "$random_base64_3",
            "secret4": "$random_base64_4",
            "secret5": "$random_base64_5",
            "secret6": "$random_base64_6",
            "secret7": "$random_base64_7",
            "secret8": "$random_base64_8",
            "secret9": "$random_base64_9",
            "secret10": "$random_base64_10"
        }
    }
EOF
}

for i in $(seq $start $(expr $start + $n - 1)); do
    secretWithoutData | oc create -f -
    secretWithRandomBase64Data | oc create -f -
    oc create secret generic -n "$namespace" "secret-$i-of-$n-withsshkey" --from-file=ssh-privatekey=intentionally_published_private_ssh_key --from-file=ssh-publickey=intentionally_published_public_ssh_key
done

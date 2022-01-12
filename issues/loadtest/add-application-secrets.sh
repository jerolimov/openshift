#!/bin/bash

#set -e

start=1
n=100

namespace="loadtest-$n-deployments"

function patch_deployment() {
    secret=$1
cat <<EOF
    [
        {
            "op": "replace",
            "path": "/spec/template/spec/containers/0/env",
            "value": [
                {
                    "name":"privatekey",
                    "valueFrom": {
                        "secretKeyRef": {
                            "name": "$secret",
                            "key":"ssh-publickey"
                        }
                    }
                },
                {
                    "name":"publickey",
                    "valueFrom": {
                        "secretKeyRef": {
                            "name": "$secret",
                            "key":"ssh-publickey"
                        }
                    }
                }
            ]
        },
        {
            "op": "replace",
            "path": "/spec/template/spec/containers/0/envFrom",
            "value": [
                {
                    "prefix": "sshkeys",
                    "secretRef": {
                        "name": "$secret"
                    }
                }
            ]
        }
    ]
EOF
}

for i in $(seq $start $(expr $start + $n - 1)); do
    deployment="deployment-$i-of-$n"
    secret="secret-$i-of-$n-withsshkey"
    
    echo "Add secret $secret to $deployment"
    oc patch -n "$namespace" Deployment "$deployment" --type json --patch "$(patch_deployment "$secret")"
done

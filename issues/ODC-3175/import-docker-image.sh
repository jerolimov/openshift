#!/bin/bash

set -e

NOW=$(date +"%H-%M-%S")
APP="app-$NOW"
DEPLOYMENT="nodeinfo-$NOW-deployment"
NAMESPACE=$(oc project -q)

DOCKER_IMAGE=jerolimov/nodeinfo

echo
echo "Create app \"$APP\" with Deployment \"$DEPLOYMENT\" in namespace \"$NAMESPACE\"..."
echo

function imagestream {
cat <<EOF
{
    "apiVersion": "image.openshift.io/v1",
    "kind": "ImageStream",
    "metadata": {
        "name": "$DEPLOYMENT",
        "namespace": "$NAMESPACE",
        "labels": {
            "app": "$DEPLOYMENT",
            "app.kubernetes.io/instance": "$DEPLOYMENT",
            "app.kubernetes.io/component": "$DEPLOYMENT",
            "app.kubernetes.io/part-of": "$APP"
        }
    },
    "spec": {
        "tags": [
            {
                "name": "latest",
                "annotations": {
                    "openshift.io/generated-by": "OpenShiftWebConsole",
                    "openshift.io/imported-from": "$DOCKER_IMAGE"
                },
                "from": {
                    "kind": "DockerImage",
                    "name": "$DOCKER_IMAGE"
                },
                "importPolicy": {
                    "insecure": false
                }
            }
        ]
    }
}
EOF
}

function deployment {
cat <<EOF
{
    "kind": "Deployment",
    "apiVersion": "apps/v1",
    "metadata": {
        "name": "$DEPLOYMENT",
        "namespace": "$NAMESPACE",
        "labels": {
            "app": "$DEPLOYMENT",
            "app.kubernetes.io/instance": "$DEPLOYMENT",
            "app.kubernetes.io/component": "$DEPLOYMENT",
            "app.kubernetes.io/part-of": "$APP",
            "app.openshift.io/runtime-namespace": "$NAMESPACE"
        },
        "annotations": {
            "openshift.io/generated-by": "OpenShiftWebConsole",
            "alpha.image.policy.openshift.io/resolve-names": "*",
            "image.openshift.io/triggers": "[{\\"from\\":{\\"kind\\":\\"ImageStreamTag\\",\\"name\\":\\"$DEPLOYMENT:latest\\",\\"namespace\\":\\"$NAMESPACE\\"},\\"fieldPath\\":\\"spec.template.spec.containers[?(@.name==\\\\\\"$DEPLOYMENT\\\\\\")].image\\",\\"pause\\":\\"false\\"}]"
        }
    },
    "spec": {
        "replicas": 1,
        "selector": {
            "matchLabels": {
                "app": "$DEPLOYMENT"
            }
        },
        "template": {
            "metadata": {
                "labels": {
                    "app": "$DEPLOYMENT",
                    "deploymentconfig": "$DEPLOYMENT"
                },
                "annotations": {
                    "openshift.io/generated-by": "OpenShiftWebConsole"
                }
            },
            "spec": {
                "volumes": [],
                "containers": [
                    {
                        "name": "$DEPLOYMENT",
                        "image": "$DEPLOYMENT:latest",
                        "ports": [
                            {
                                "containerPort": 8080,
                                "protocol": "TCP"
                            }
                        ],
                        "volumeMounts": [],
                        "env": [],
                        "resources": {}
                    }
                ]
            }
        }
    }
}
EOF
}

function log_json {
    pipe_input=$(cat)
    echo $*
    echo "$pipe_input" | jq .
    echo
}

function create {
    pipe_input=$(cat)
    #echo $*
    echo "$pipe_input" | oc create -f -
    #echo
}

echo "Will create this resources..."
echo
imagestream   | log_json "ImageStream:"
deployment    | log_json "Deployment:"

echo "Create resources..."
echo
imagestream   | create
deployment    | create

echo
echo "Get latest events and grep for $NOW"
echo

oc get events -w | grep "$NOW"

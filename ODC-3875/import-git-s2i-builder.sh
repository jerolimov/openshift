#!/bin/bash

set -e

NOW=$(date +"%H-%M-%S")
APP="app-$NOW"
DEPLOYMENT="nodeinfo-$NOW-deployment"
NAMESPACE=$(oc project -q)

GIT_URL=https://github.com/jerolimov/docker
CONTEXT_DIR=/nodeinfo

echo
echo "Create app \"$APP\" with BuildConfig & Deployment \"$DEPLOYMENT\" in namespace \"$NAMESPACE\"..."
echo
echo "Based on nodejs app in \"$GIT_URL\" (context dir: \"$CONTEXT_DIR\")"
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
            "app.kubernetes.io/name": "nodejs",
            "app.openshift.io/runtime": "nodejs",
            "app.kubernetes.io/part-of": "$APP",
            "app.openshift.io/runtime-version": "12"
        },
        "annotations": {
            "app.openshift.io/vcs-uri": "$GIT_URL",
            "app.openshift.io/vcs-ref": "master",
            "openshift.io/generated-by": "OpenShiftWebConsole"
        }
    }
}
EOF
}

function buildconfig {
cat <<EOF
{
    "apiVersion": "build.openshift.io/v1",
    "kind": "BuildConfig",
    "metadata": {
        "name": "$DEPLOYMENT",
        "namespace": "$NAMESPACE",
        "labels": {
            "app": "$DEPLOYMENT",
            "app.kubernetes.io/instance": "$DEPLOYMENT",
            "app.kubernetes.io/component": "$DEPLOYMENT",
            "app.kubernetes.io/name": "nodejs",
            "app.openshift.io/runtime": "nodejs",
            "app.kubernetes.io/part-of": "$APP",
            "app.openshift.io/runtime-version": "12"
        },
        "annotations": {
            "app.openshift.io/vcs-uri": "$GIT_URL",
            "app.openshift.io/vcs-ref": "master",
            "openshift.io/generated-by": "OpenShiftWebConsole"
        }
    },
    "spec": {
        "output": {
            "to": {
                "kind": "ImageStreamTag",
                "name": "$DEPLOYMENT:latest"
            }
        },
        "source": {
            "contextDir": "$CONTEXT_DIR",
            "git": {
                "uri": "$GIT_URL",
                "ref": "",
                "type": "Git"
            }
        },
        "strategy": {
            "type": "Source",
            "sourceStrategy": {
                "env": [],
                "from": {
                    "kind": "ImageStreamTag",
                    "name": "nodejs:12",
                    "namespace": "openshift"
                }
            }
        },
        "triggers": [
            {
                "type": "ImageChange",
                "imageChange": {}
            },
            {
                "type": "ConfigChange"
            }
        ]
    }
}
EOF
}

function deployment {
cat <<EOF
{
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "name": "$DEPLOYMENT",
        "namespace": "$NAMESPACE",
        "labels": {
            "app": "$DEPLOYMENT",
            "app.kubernetes.io/instance": "$DEPLOYMENT",
            "app.kubernetes.io/component": "$DEPLOYMENT",
            "app.kubernetes.io/name": "nodejs",
            "app.openshift.io/runtime": "nodejs",
            "app.kubernetes.io/part-of": "$APP",
            "app.openshift.io/runtime-version": "12"
        },
        "annotations": {
            "app.openshift.io/vcs-uri": "$GIT_URL",
            "app.openshift.io/vcs-ref": "master",
            "openshift.io/generated-by": "OpenShiftWebConsole",
            "alpha.image.policy.openshift.io/resolve-names": "*",
            "image.openshift.io/triggers": "[{\\"from\\":{\\"kind\\":\\"ImageStreamTag\\",\\"name\\":\\"$DEPLOYMENT:latest\\",\\"namespace\\":\\"$NAMESPACE\\"},\\"fieldPath\\":\\"spec.template.spec.containers[?(@.name==\\\\\\"$DEPLOYMENT\\\\\\")].image\\",\\"pause\\":\\"false\\"}]"
        }
    },
    "spec": {
        "selector": {
            "matchLabels": {
                "app": "$DEPLOYMENT"
            }
        },
        "replicas": 1,
        "template": {
            "metadata": {
                "labels": {
                    "app": "$DEPLOYMENT",
                    "deploymentconfig": "$DEPLOYMENT"
                }
            },
            "spec": {
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
buildconfig   | log_json "BuildConfig:"
deployment    | log_json "Deployment:"

echo "Create resources..."
echo
imagestream   | create
buildconfig   | create
deployment    | create

echo
echo "Get latest events and grep for $NOW"
echo

oc get events -w | grep "$NOW"

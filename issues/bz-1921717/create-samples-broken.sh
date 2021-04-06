#!/bin/bash

set -e

NAMESPACE=$(oc project -q)

function imagestream {
cat <<EOF
{
  "apiVersion": "image.openshift.io/v1",
  "kind": "ImageStream",
  "metadata": {
    "name": "golang-sample-$SUFFIX",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "golang-sample-$SUFFIX",
      "app.kubernetes.io/instance": "golang-sample-$SUFFIX",
      "app.kubernetes.io/component": "golang-sample-$SUFFIX",
      "app.kubernetes.io/name": "golang",
      "app.openshift.io/runtime": "golang",
      "app.kubernetes.io/part-of": "sample-app",
      "app.openshift.io/runtime-version": "1.13.4-ubi7"
    },
    "annotations": {
      "app.openshift.io/vcs-uri": "https://github.com/sclorg/golang-ex.git",
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
    "name": "golang-sample-$SUFFIX",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "golang-sample-$SUFFIX",
      "app.kubernetes.io/instance": "golang-sample-$SUFFIX",
      "app.kubernetes.io/component": "golang-sample-$SUFFIX",
      "app.kubernetes.io/name": "golang",
      "app.openshift.io/runtime": "golang",
      "app.kubernetes.io/part-of": "sample-app",
      "app.openshift.io/runtime-version": "1.13.4-ubi7"
    },
    "annotations": {
      "app.openshift.io/vcs-uri": "https://github.com/sclorg/golang-ex.git",
      "app.openshift.io/vcs-ref": "master",
      "openshift.io/generated-by": "OpenShiftWebConsole"
    }
  },
  "spec": {
    "output": {
      "to": { "kind": "ImageStreamTag", "name": "golang-sample-$SUFFIX:latest" }
    },
    "source": {
      "contextDir": "",
      "git": {
        "uri": "https://github.com/sclorg/golang-ex.git",
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
          "name": "golang:1.13.4-ubi7",
          "namespace": "openshift"
        }
      }
    },
    "triggers": [
      {
        "type": "Generic",
        "generic": {
          "secretReference": {
            "name": "golang-sample-$SUFFIX-generic-webhook-secret"
          }
        }
      },
      {
        "type": "GitHub",
        "github": {
          "secretReference": {
            "name": "golang-sample-$SUFFIX-github-webhook-secret"
          }
        }
      },
      { "type": "ImageChange", "imageChange": {} },
      { "type": "ConfigChange" }
    ]
  }
}

EOF
}

function secret1 {
cat <<EOF
{
  "apiVersion": "v1",
  "data": {},
  "kind": "Secret",
  "metadata": {
    "name": "golang-sample-$SUFFIX-generic-webhook-secret",
    "namespace": "$NAMESPACE"
  },
  "stringData": { "WebHookSecretKey": "052ac21b35d89b90" },
  "type": "Opaque"
}
EOF
}

function deployment {
cat <<EOF
{
  "apiVersion": "apps/v1",
  "kind": "Deployment",
  "metadata": {
    "name": "golang-sample-$SUFFIX",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "golang-sample-$SUFFIX",
      "app.kubernetes.io/instance": "golang-sample-$SUFFIX",
      "app.kubernetes.io/component": "golang-sample-$SUFFIX",
      "app.kubernetes.io/name": "golang",
      "app.openshift.io/runtime": "golang",
      "app.kubernetes.io/part-of": "sample-app",
      "app.openshift.io/runtime-version": "1.13.4-ubi7"
    },
    "annotations": {
      "app.openshift.io/vcs-uri": "https://github.com/sclorg/golang-ex.git",
      "app.openshift.io/vcs-ref": "master",
      "openshift.io/generated-by": "OpenShiftWebConsole",
      "alpha.image.policy.openshift.io/resolve-names": "*",
      "image.openshift.io/triggers": "[{\"from\":{\"kind\":\"ImageStreamTag\",\"name\":\"golang-sample-$SUFFIX:latest\",\"namespace\":\"$NAMESPACE\"},\"fieldPath\":\"spec.template.spec.containers[?(@.name==\"golang-sample-$SUFFIX\")].image\",\"pause\":\"false\"}]"
    }
  },
  "spec": {
    "selector": { "matchLabels": { "app": "golang-sample-$SUFFIX" } },
    "replicas": 1,
    "template": {
      "metadata": {
        "labels": {
          "app": "golang-sample-$SUFFIX",
          "deploymentconfig": "golang-sample-$SUFFIX"
        }
      },
      "spec": {
        "containers": [
          {
            "name": "golang-sample-$SUFFIX",
            "image": "golang-sample-$SUFFIX:latest",
            "ports": [],
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

function service {
cat <<EOF
{
  "kind": "Service",
  "apiVersion": "v1",
  "metadata": {
    "name": "golang-sample-$SUFFIX",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "golang-sample-$SUFFIX",
      "app.kubernetes.io/instance": "golang-sample-$SUFFIX",
      "app.kubernetes.io/component": "golang-sample-$SUFFIX",
      "app.kubernetes.io/name": "golang",
      "app.openshift.io/runtime": "golang",
      "app.kubernetes.io/part-of": "sample-app",
      "app.openshift.io/runtime-version": "1.13.4-ubi7"
    },
    "annotations": {
      "app.openshift.io/vcs-uri": "https://github.com/sclorg/golang-ex.git",
      "app.openshift.io/vcs-ref": "master",
      "openshift.io/generated-by": "OpenShiftWebConsole"
    }
  },
  "spec": {
    "selector": {
      "app": "golang-sample-$SUFFIX",
      "deploymentconfig": "golang-sample-$SUFFIX"
    },
    "ports": [
      {
        "port": 8080,
        "targetPort": 8080,
        "protocol": "TCP",
        "name": "8080-tcp"
      }
    ]
  }
}
EOF
}

function route {
cat <<EOF
{
  "kind": "Route",
  "apiVersion": "route.openshift.io/v1",
  "metadata": {
    "name": "golang-sample-$SUFFIX",
    "namespace": "$NAMESPACE",
    "labels": {
      "app": "golang-sample-$SUFFIX",
      "app.kubernetes.io/instance": "golang-sample-$SUFFIX",
      "app.kubernetes.io/component": "golang-sample-$SUFFIX",
      "app.kubernetes.io/name": "golang",
      "app.openshift.io/runtime": "golang",
      "app.kubernetes.io/part-of": "sample-app",
      "app.openshift.io/runtime-version": "1.13.4-ubi7"
    },
    "defaultAnnotations": {
      "app.openshift.io/vcs-uri": "https://github.com/sclorg/golang-ex.git",
      "app.openshift.io/vcs-ref": "master",
      "openshift.io/generated-by": "OpenShiftWebConsole"
    }
  },
  "spec": {
    "to": { "kind": "Service", "name": "golang-sample-$SUFFIX" },
    "host": "",
    "path": "",
    "port": { "targetPort": "8080-tcp" },
    "wildcardPolicy": "None"
  }
}
EOF
}

function secret2 {
cat <<EOF
{
  "apiVersion": "v1",
  "data": {},
  "kind": "Secret",
  "metadata": {
    "name": "golang-sample-$SUFFIX-github-webhook-secret",
    "namespace": "$NAMESPACE"
  },
  "stringData": { "WebHookSecretKey": "3670b9ae0006a36a" },
  "type": "Opaque"
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

for SUFFIX in {1..100}; do
  echo
  echo "Create golang-sample with suffix -$SUFFIX in namespace $NAMESPACE..."
  echo

  #echo "Will create this resources..."
  #echo
  #imagestream   | log_json "ImageStream:"
  #buildconfig   | log_json "BuildConfig:"
  #secret1       | log_json "Secret 1:"
  #deployment    | log_json "Deployment:"
  #service       | log_json "Service:"
  #route         | log_json "Route:"
  #secret2       | log_json "Secret 2:"

  echo "Create resources..."
  echo
  imagestream   | create &
  buildconfig   | create &
  secret1       | create &
  deployment    | create &
  service       | create &
  route         | create &
  secret2       | create &

  # Wait 2 seconds to finish background calls
  sleep 2

  echo
  echo "Wait 2 minute for build..."
  echo
  sleep 120

  replicasets=$(oc get replicasets | grep "golang-sample-$SUFFIX" | wc -l)
  if [ "$replicasets" -gt 2 ]; then
    echo
    echo "Found too much replica sets. Exit for further investigations"
    echo
    exit 1
  fi

  oc delete "deployment/golang-sample-$SUFFIX"
  oc delete "buildconfig/golang-sample-$SUFFIX"
  oc delete "service/golang-sample-$SUFFIX"
  oc delete "route/golang-sample-$SUFFIX"
  oc delete "imagestream/golang-sample-$SUFFIX"
  oc delete "secret/golang-sample-$SUFFIX-generic-webhook-secret"
  oc delete "secret/golang-sample-$SUFFIX-github-webhook-secret"

  sleep 1

done

#echo
#echo "Get latest events and grep for $NOW"
#echo

# oc get events -w | grep "$SUFFIX"

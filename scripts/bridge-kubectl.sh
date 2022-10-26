#!/usr/bin/env bash

set -euo pipefail

CONSOLE_DIR="$HOME/git/openshift/console"

CONSOLE_SERVICE_ACCOUNT_NAMESPACE=${CONSOLE_SERVICE_ACCOUNT_NAMESPACE:=kube-system}
CONSOLE_SERVICE_ACCOUNT_NAME=${CONSOLE_SERVICE_ACCOUNT_NAME:=console-admin}

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: $CONSOLE_SERVICE_ACCOUNT_NAMESPACE
  name: $CONSOLE_SERVICE_ACCOUNT_NAME
EOF

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $CONSOLE_SERVICE_ACCOUNT_NAME
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  namespace: $CONSOLE_SERVICE_ACCOUNT_NAMESPACE
  name: $CONSOLE_SERVICE_ACCOUNT_NAME
EOF

export BRIDGE_USER_AUTH="disabled"

export BRIDGE_K8S_MODE="off-cluster"
export BRIDGE_K8S_MODE_OFF_CLUSTER_ENDPOINT=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
export BRIDGE_K8S_MODE_OFF_CLUSTER_SKIP_VERIFY_TLS=true

export BRIDGE_K8S_AUTH="bearer-token"
export BRIDGE_K8S_AUTH_BEARER_TOKEN=$(kubectl create token -n "$CONSOLE_SERVICE_ACCOUNT_NAMESPACE" "$CONSOLE_SERVICE_ACCOUNT_NAME")

echo
echo "Start console bridge ($CONSOLE_DIR) without authentification!"
echo
echo "Using k8s api $BRIDGE_K8S_MODE_OFF_CLUSTER_ENDPOINT with service-account $CONSOLE_SERVICE_ACCOUNT_NAME (namespace $CONSOLE_SERVICE_ACCOUNT_NAMESPACE)"
echo

cd "$CONSOLE_DIR" && ./bin/bridge

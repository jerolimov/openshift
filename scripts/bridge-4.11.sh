cd ~/git/openshift/console-4.11 && \
export KUBECONFIG=~/.crc/machines/crc/kubeconfig && \
oc login -u kubeadmin -p $(cat ~/.crc/machines/crc/kubeadmin-password) --server https://api.crc.testing:6443 && \
source ./contrib/oc-environment.sh && \
bin/bridge -listen http://0.0.0.0:9011 -user-settings-location configmap


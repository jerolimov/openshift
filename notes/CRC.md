# CRC

## Download

* Requires a [Red Hat account / subscription](https://www.redhat.com/)
* [Download page](https://cloud.redhat.com/openshift/install/crc/installer-provisioned) which contains also the Pull Secret

## Setup

```bash
# Increase node memory limit from default 9 GB to 16 GB
crc config set memory 16384

crc

crc start
```

## Connect local console

```bash
export KUBECONFIG=~/.crc/machines/crc/kubeconfig

oc login -u kubeadmin -p $(cat $HOME/.crc/cache/crc_libvirt_4.4.8/kubeadmin-password)

source ./contrib/oc-environment.sh

bin/bridge
```

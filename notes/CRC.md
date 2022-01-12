# CRC

## Download

* Requires a [Red Hat account / subscription](https://www.redhat.com/)
* [Download page](https://cloud.redhat.com/openshift/install/crc/installer-provisioned) which contains also the Pull Secret
* [Documentation](https://code-ready.github.io/crc/)

## Setup

```bash
crc config set consent-telemetry no
crc config set enable-cluster-monitoring false
crc config set cpus 12
crc config set memory 24576
crc config set disk-size 100
```

With monitoring:

```bash
crc config set consent-telemetry no
crc config set enable-cluster-monitoring true
crc config set cpus 12
crc config set memory 24576
crc config set disk-size 100
```

Delete and create a new setup


```bash
crc stop; crc delete -f; crc setup && crc start
```

## Connect local console

```bash
export KUBECONFIG=~/.crc/machines/crc/kubeconfig

oc login -u kubeadmin -p $(cat ~/.crc/machines/crc/kubeadmin-password)

source ./contrib/oc-environment.sh

bin/bridge
```

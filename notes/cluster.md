# A 'shared' cluster

## AWS

You need to setup aws cli and credentials to start a shared cluster. (TODO)

## openshift-install

0. The OpenShift installer use terraform to create a cluster and saves the created resources in a local state file.

    ```bash
    mkdir ~/shared-cluster && cd ~/shared-cluster
    ```

1. Download installer and pull secret from https://console.redhat.com/openshift/install/aws/installer-provisioned

    You can also download a nightly build from https://amd64.ocp.releases.ci.openshift.org/#4.12.0-0.nightly

2. To get access to image registry, you need an API token from https://oauth-openshift.apps.ci.l2s4.p1.openshiftapps.com/oauth/token/display

    ```bash
    oc login --token=...                       # copied command
    oc registry login --to ./pull-secret.txt   # extends your downloaded pull-secret.txt
    ```

3. Minift the JSON

    ```bash
    jq -cM . pull-secret.txt > pull-secret.json
    ```

4. Create a cluster:

    ```bash
    ./openshift-install create cluster --log-level debug
    ```

    This will take ~35 minutes to setup a cluster.

5. Destroy your cluster if not needed anymore:

    ```bash
    ./openshift-install destroy cluster
    ```

<!--
## Disconnected cluster

Don't know yet :)
-->

## Disable some capabilities

Step 0-3 and 5 as described above.

4. Instead of creating the cluster with a default configuration,
    you need to create a configuration yaml first,
    modifying it and then create the cluster.

    ```bash
    ./openshift-install create install-config
    ```

    For capabilities configuration options see:

    1. https://docs.openshift.com/container-platform/4.11/post_installation_configuration/cluster-capabilities.html
    2. https://github.com/openshift/installer/blob/master/docs/user/customization.md
    3. https://github.com/openshift/installer/blob/master/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L312

    Edit `install-config.yaml` and add this sections:

    [4.11 defaults](https://github.com/openshift/installer/blob/release-4.11/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L278-L291) / without samples:

    ```yaml
    capabilities:
    baselineCapabilitySet: None
    additionalEnabledCapabilities:
    - baremetal
    - marketplace
    # - openshift-samples
    ```

    [4.12 defaults]([https://github.com/openshift/installer/blob/release-4.12/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L273-L282](https://github.com/openshift/installer/blob/release-4.12/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L311-L337)) / without samples:

    ```yaml
    capabilities:
    baselineCapabilitySet: None
    additionalEnabledCapabilities:
    - baremetal
    - marketplace
    - Console
    - Insights
    - Storage
    # - openshift-samples
    - CSISnapshot
    ```

    [4.14 defaults]([[https://github.com/openshift/installer/blob/release-4.12/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L273-L282](https://github.com/openshift/installer/blob/release-4.12/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L311-L337](https://github.com/openshift/installer/blob/release-4.14/vendor/github.com/openshift/api/config/v1/types_cluster_version.go#L389-L442))) / without samples, build and DeploymentConfig:

    ```yaml
    capabilities:
    baselineCapabilitySet: None
    additionalEnabledCapabilities:
    - baremetal
    - Console
    - Insights
    - marketplace
    - Storage
    # - openshift-samples
    - CSISnapshot
    - NodeTuning
    - MachineAPI
    # - Build
    # - DeploymentConfig
    ```

    ⚠️ The changed `install-config.yaml` is removed when creating the cluster.

    Continue with:

    ```bash
    ./openshift-install create cluster --log-level debug
    ```

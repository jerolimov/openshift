# Unmanaged state

## Disable `BuildConfigs` on a running cluster

To remove the `BuildConfig` and `Build` API, it's required to set the OpenShift APIServer to **Unmanaged** and remove the `v1.build.openshift.io` APIService:

```
oc patch openshiftapiservers.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Unmanaged"}}'
oc delete apiservices.apiregistration.k8s.io v1.build.openshift.io
```

## Disable `DeploymentConfigs` on a running cluster

To remove the `DeploymentConfig` API, it's also required to set the OpenShift APIServer to **Unmanaged** and remove the `v1.apps.openshift.io` (not `v1.apps`) APIService:

```
oc patch openshiftapiservers.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Unmanaged"}}'
oc delete apiservices.apiregistration.k8s.io v1.apps.openshift.io
```

## Restore `BuildConfigs` and `DeploymentConfigs`

To restore both APIs (and maybe others if manually removed on that cluster), you just can simple switch the OpenShift APIServer back to **Managed**:

```
oc patch openshiftapiservers.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Managed"}}'
oc get apiservices.apiregistration.k8s.io v1.build.openshift.io v1.apps.openshift.io
```

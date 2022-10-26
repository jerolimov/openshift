## Customization

http://localhost:9012/k8s/cluster/operator.openshift.io~v1~Console/cluster/yaml

## Don't override the CRDs

http://localhost:9012/k8s/cluster/config.openshift.io~v1~ClusterVersion/version/yaml

```yaml
spec:
  overrides:
    - group: apiextensions.k8s.io
      kind: CustomResourceDefinition
      name: consoles.operator.openshift.io
      namespace: ''
      unmanaged: true
```

## CRD

http://localhost:9012/k8s/cluster/customresourcedefinitions/consoles.operator.openshift.io

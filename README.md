# Helm Charts

## Usage
### Helm repo

```shell
helm repo add tamcore https://tamcore.github.io/charts/
helm repo update
```

### OCI registry

```shell
# fetch chart versions
skopeo list-tags docker://ghcr.io/tamcore/charts/${CHART_NAME}
# or
crane ls ghcr.io/tamcore/charts/${CHART_NAME}

# deploy
helm upgrade --install \
    ${CHART_NAME} \
    oci://ghcr.io/tamcore/charts/${CHART_NAME} \
    --version ${CHART_VERSION} \
    --namespace ${NAMESPACE}
```

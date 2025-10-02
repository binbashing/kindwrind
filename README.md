

# Kubernetes in Docker with Registry in Docker
![Build and Push](https://github.com/binbashing/kindwrind/actions/workflows/merge-build-push.yaml/badge.svg)
![Integration Tests](https://github.com/binbashing/kindwrind/actions/workflows/integration-tests.yml/badge.svg)
![Update Check](https://github.com/binbashing/kindwrind/actions/workflows/update-check.yaml/badge.svg)
<p align="left">
    <img src="https://raw.githubusercontent.com/binbashing/kindwrind/main/kindwrind.png" alt="kindwrind logo" width="300"/>
</p>

**kindwrind** is a tool for running [Kind](https://kind.sigs.k8s.io/) and [Registry](https://hub.docker.com/_/registry) inside a single container using [DinD](https://hub.docker.com/_/docker).
</br>
kindwrind was primarily created for local development or CI.
</br>
If you have [Docker](https://docs.docker.com/get-started/get-docker/) installed and the abilty to [Escalate container privileges](https://docs.docker.com/reference/cli/docker/container/run/#privileged)
```bash
docker run -d \
    --privileged \
    --name kindwrind \
    -p 6443:6443 \
    -p 5000:5000 \
    -v ${KUBECONFIG:-~/.kube/config}:/kubeconfig/config \
    binbashing/kindwrind
```
is all you need!


---
## Example usage:

```yaml
# docker-compose.yaml
services:
    kindwrind:
        image: binbashing/kindwrind
        privileged: true
        ports:
            - 6443:6443
            - 5000:5000
        volumes:
            - ${KUBECONFIG_DIR:-~/.kube}:/kubeconfig
```

```bash
# Start kindwrind
docker compose up -d

# Pull a public image
docker pull nginx:latest

## Tag image for local registry
docker tag nginx:latest localhost:5000/nginx:latest

## Push image to local registry
docker push localhost:5000/nginx:latest

## Create a Kubernetes deployment using the local registry image
kubectl create deployment hello-server --image=localhost:5000/nginx:latest 
```

> **Note**: You can specify a custom Kubernetes version using the `KUBERNETES_VERSION` environment variable (e.g., `KUBERNETES_VERSION=v1.33.0`). When set, Kind will create the cluster using `--image kindest/node:$KUBERNETES_VERSION`.

## License

This project is licensed under the [Apache License 2.0](LICENSE).

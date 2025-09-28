![Build and Push](https://github.com/binbashing/kindwrind/actions/workflows/merge-build-push.yaml/badge.svg)
![Integration Tests](https://github.com/binbashing/kindwrind/actions/workflows/integration-tests.yml/badge.svg)
![Version Check](https://github.com/binbashing/kindwrind/actions/workflows/version-check.yaml/badge.svg)

# KinDwRinD
[Kubernetes in Docker](https://kind.sigs.k8s.io/) with [Registry](https://docs.docker.com/registry/) in [Docker](https://hub.docker.com/_/docker) (KinDwRinD) is a project that provides a Dockerized environment for running an emphemeral Kubernetes cluster using KinD (Kubernetes in Docker).   The intent of this project is for CI/CD pipelines and quickly running Kubernetes locally. 

## Usage

#### Setup:

docker-compose
```yaml
services:
    kindwrind:
        image: binbashing/kindwrind
        container_name: kindwrind
        ports:
            - 6443:6443
            - 5000:5000
        volumes:
            - ~/.kube:/kubeconfig
```

docker cli
```bash
docker run -d \
    --privileged \
    --name kindwrind \
    -p 6443:6443 \
    -p 5000:5000 \
    -v ~/.kube:/kubeconfig \
    binbashing/kindwrind
```
#### Example usage:

```bash
# Start KinDwRinD
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

## License

This project is licensed under the [Apache License 2.0](LICENSE).

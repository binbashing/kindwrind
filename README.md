![Build and Push](https://github.com/binbashing/kindwrind/actions/workflows/merge-build-push.yaml/badge.svg)
![Tag and Push](https://github.com/binbashing/kindwrind/actions/workflows/release-tag-push.yaml/badge.svg)

# KinDwRinD
[Kubernetes in Docker](https://kind.sigs.k8s.io/) With [Registry](https://docs.docker.com/registry/) in [Docker](https://hub.docker.com/_/docker) (KinDwRinD) is a project that provides a Dockerized environment for running an emphemeral Kubernetes cluster using KinD (Kubernetes in Docker).   The intent of this project is for CI/CD pipelines and quickly running Kubernetes locally. 

## Usage

#### Setup:

docker-compose
```
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
```
docker run -d \
    --privileged \
    --name kindwrind \
    -p 6443:6443 \
    -p 5000:5000 \
    -v ~/.kube:/kubeconfig \
    binbashing/kindwrind
```
#### Example usage:

Pull a public image
```
docker pull nginx:latest
```

Tag image for local registry
```
docker tag nginx:latest localhost:5000/nginx:latest
```

Push image to local registry
```
docker push localhost:5000/nginx:latest
```
Create a Kubernetes deployment using the local registry image
```
kubectl create deployment hello-server --image=localhost:5000/nginx:latest 
```

## License

This project is licensed under the [Apache License 2.0](LICENSE).

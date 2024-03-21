# KinDwRinD
Kubernetes in Docker With Registry in Docker (KinDwRinD) is a project that provides a Dockerized environment for running Kubernetes emphemeral clusters using KinD (Kubernetes in Docker).   The intent of this project is for CI/CD pipelines and quickly running Kubernetes locally.This repository contains the Dockerfile and GitHub Actions workflows necessary to build and push the Kindwrind Docker image to Docker Hub.

## Usage

To help you get started running this image you can either use docker-compose or the docker cli.

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


### GitHub Actions Workflows

This repository contains GitHub Actions workflows that automate the build and push process. Container images are built, tagged `latest` and pushed to Docker Hub on merge to main.
Container images are version tagged and pushed to Docker Hub on release tagging.

## Contributing

We welcome contributions from the community. If you encounter any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [Apache License 2.0](LICENSE).

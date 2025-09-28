#!/bin/sh

set -e

handle_sigterm() {
    echo "SIGTERM received, deleting cluster ..."
    kind delete cluster --name kindwrind
    exit 0
}

# Setup SIGTERM handler
trap handle_sigterm TERM

# Start the dockerd daemon and put it in the background
dockerd-entrypoint.sh &

# Wait for the dockerd daemon to be ready
echo waiting for docker dind service...
if ! docker version >/dev/null 2>&1; then
    count=0
    while [ $count -lt 30 ]; do
        printf '.'
        sleep 1
        if docker version >/dev/null 2>&1; then
            echo
            break
        fi
        count=$((count+1))
    done
    if [ $count -eq 30 ]; then
        echo >&2 "Timeout waiting for docker service"
        exit 1
    fi
fi

# Create KinD cluster
if [ -n "$KUBERNETES_VERSION" ]; then
    echo "Creating KinD cluster with Kubernetes version: $KUBERNETES_VERSION"
    kind create cluster --config /kindind-config.yaml --name kindwrind --image "kindest/node:$KUBERNETES_VERSION" --wait 5m
else
    echo "Creating KinD cluster with default Kubernetes version"
    kind create cluster --config /kindind-config.yaml --name kindwrind --wait 5m
fi

# Setup Docker Registy
docker run -d --name registry --restart=always --net=kind -p 5000:5000 registry:2

# Keep script running to maintain control over the process and handle signals
wait $!
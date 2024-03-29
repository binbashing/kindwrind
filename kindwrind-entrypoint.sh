#!/bin/sh

set -e

handle_sigterm() {
    echo "SIGTERM received, deleting cluster ..."
    /usr/bin/kind delete cluster stop
    exit 0
}

# Setup SIGTERM handler
trap handle_sigterm SIGTERM

# Start the dockerd daemon and put it in the background
dockerd-entrypoint.sh &

# Wait for the dockerd daemon to be ready
echo waiting for docker dind service...
if ! docker version >/dev/null 2>&1; then
	for i in $(seq 1 30); do
		echo -n .
		sleep 1
		docker version >/dev/null 2>&1 && break
	done
	if [ $? = 0 ]; then
		echo
	else
		echo >&2 "Timeout waiting for docker service"
		exit 1
	fi
fi

# Create KinD cluster
kind create cluster --config /kindind-config.yaml --name kindwrind --wait 5m

# Setup Docker Registy
docker run -d --name registry --restart=always --net=kind -p 5000:5000 registry:2

# Keep script running to maintain control over the process and handle signals
wait $!
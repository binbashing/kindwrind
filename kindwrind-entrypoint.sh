#!/bin/sh

set -e

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

# Gracefully shutdown the KinD cluster when this script exits
trap 'kind delete cluster' 0 1 2 3 15
tail -f /dev/null &
wait $!
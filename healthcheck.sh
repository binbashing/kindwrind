#!/bin/sh

# Health check script for kindwrind
# Checks that both Kubernetes API and Docker Registry are accessible

set -e

# Check Kubernetes API health endpoint
if ! curl --insecure -f https://localhost:6443/readyz >/dev/null 2>&1; then
    echo "Kubernetes API not healthy"
    exit 1
fi

# Check Docker Registry API
if ! curl -f http://localhost:5000/v2/ >/dev/null 2>&1; then
    echo "Docker Registry not healthy" 
    exit 1
fi

echo "All services healthy"
exit 0
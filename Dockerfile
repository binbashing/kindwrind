# Use Docker-in-Docker base image
FROM docker:dind

# Define a build argument for the platform
ARG PLATFORM

# Set default value for the platform argument (if not provided during build)
ARG PLATFORM=linux/amd64

# Install necessary dependencies
RUN apk add --no-cache curl go kubectl

# Extract the architecture name from the platform argument
# This assumes that the platform argument follows the format 'linux/{architecture}'
# We'll use parameter expansion to remove the 'linux/' prefix
# For example, if PLATFORM=linux/arm64, then ARCH=arm64
RUN ARCH=$(echo $PLATFORM | cut -d'/' -f2) && \
    # Download and install KinD based on the architecture
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-$ARCH && \
    chmod +x ./kind && \
    mv ./kind /bin/kind && \
    mkdir /kubeconfig

# Set default Kubeconfig path
ENV KUBECONFIG=/kubeconfig/config

# Copy necessary files
COPY kindind-config.yaml /kindind-config.yaml
COPY kindwrind-entrypoint.sh /kindwrind-entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/kindwrind-entrypoint.sh"]
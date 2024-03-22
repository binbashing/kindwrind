# Use Docker-in-Docker base image
FROM docker:dind

# Define a build argument for the platform
ARG TARGETPLATFORM

# Set default value for the platform argument (if not provided during build)

# Install necessary dependencies
RUN apk add --no-cache curl kubectl

# Install KinD
RUN ARCH=$(echo $TARGETPLATFORM | cut -d'/' -f2) && \
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
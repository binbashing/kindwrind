# Use Docker-in-Docker base image
FROM docker:dind

# Define build arguments
ARG TARGETPLATFORM
ARG KIND_VERSION

# Set build-time labels
LABEL org.opencontainers.image.version="${KIND_VERSION}"
LABEL org.opencontainers.image.title="KinDwRinD"
LABEL org.opencontainers.image.description="Kubernetes in Docker with Registry in Docker"
LABEL kindwrind.kind.version="${KIND_VERSION}"
LABEL kindwrind.version="${KIND_VERSION}"

# Install necessary dependencies
RUN apk add --no-cache curl kubectl

# Install KinD with version from build argument
RUN ARCH=$(echo $TARGETPLATFORM | cut -d'/' -f2) && \
    # Download and install KinD based on the architecture and version from build argument
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-$ARCH && \
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
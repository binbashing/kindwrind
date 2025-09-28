# Use Docker-in-Docker base image
FROM docker:dind

# Define build arguments
ARG TARGETARCH
ARG KIND_VERSION

# Set build-time labels
LABEL org.opencontainers.image.version="${KIND_VERSION}"
LABEL org.opencontainers.image.title="KinDwRinD"
LABEL org.opencontainers.image.description="Kubernetes in Docker with Registry in Docker"

# Install dependencies
RUN apk add --no-cache curl kubectl

# Download and install KinD based on the architecture and version from build argument
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-${TARGETARCH} && \
    chmod +x ./kind && \
    mv ./kind /bin/kind && \
    mkdir /kubeconfig

# Set default Kubeconfig path
ENV KUBECONFIG=/kubeconfig/config

# Copy necessary files
COPY kindind-config.yaml /kindind-config.yaml
COPY kindwrind-entrypoint.sh /kindwrind-entrypoint.sh
COPY healthcheck.sh /healthcheck.sh

# Make scripts executable
RUN chmod +x /kindwrind-entrypoint.sh /healthcheck.sh

# Expose ports
EXPOSE 6443 5000

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD /healthcheck.sh

# Set the entrypoint script
ENTRYPOINT ["/kindwrind-entrypoint.sh"]
# Use Docker-in-Docker base image
FROM docker:dind

# Define build arguments
ARG TARGETARCH
ARG KIND_VERSION

# Set build-time labels
LABEL org.opencontainers.image.version="${KIND_VERSION}"
LABEL org.opencontainers.image.title="kindwrind"
LABEL org.opencontainers.image.description="Kubernetes in Docker with Registry in Docker"

# Set default Kubeconfig path
ENV KUBECONFIG=/kubeconfig/config

# Install dependencies
RUN apk add --no-cache curl

# Copy necessary files
COPY kindind-config.yaml /kindind-config.yaml
COPY kindwrind-entrypoint.sh /kindwrind-entrypoint.sh
COPY healthcheck.sh /healthcheck.sh
ADD https://kind.sigs.k8s.io/dl/v${KIND_VERSION}/kind-linux-${TARGETARCH} /bin/kind

# Make scripts executable
RUN chmod +x /bin/kind /kindwrind-entrypoint.sh /healthcheck.sh

# Expose ports
EXPOSE 6443 5000

# Set the health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD /healthcheck.sh

# Set the entrypoint script
ENTRYPOINT ["/kindwrind-entrypoint.sh"]
ARG ARCH=amd64
FROM docker:dind


RUN apk add curl go
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-${ARCH} && \
    chmod +x ./kind && \
    mv ./kind /bin/kind && \
    mkdir /kubeconfig

ENV KUBECONFIG=/kubeconfig/config

COPY kindind-config.yaml /kindind-config.yaml
COPY kindwrind-entrypoint.sh /kindwrind-entrypoint.sh

ENTRYPOINT [ "/kindwrind-entrypoint.sh" ]
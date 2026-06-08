FROM oryd/talos:v26.2.0

# Install envsubst for config variable substitution
USER root
RUN apk add --no-cache gettext
USER ory

WORKDIR /etc/talos

COPY talos.yml /etc/talos/talos.yml
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

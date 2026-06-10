FROM oryd/talos:v26.2.0

# Install envsubst for config variable substitution and create runtime dirs
USER root
RUN apk add --no-cache gettext su-exec \
    && addgroup -S ory 2>/dev/null || true \
    && adduser -S -G ory ory 2>/dev/null || true \
    && mkdir -p /var/lib/talos \
    && chown -R ory:ory /var/lib/talos
# Stay as root so entrypoint can fix volume mount permissions at runtime

WORKDIR /etc/talos

COPY talos/talos.yml /etc/talos/talos.yml
COPY --chmod=755 talos/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

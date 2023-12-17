FROM alpine:3.19

# Install dependencies
RUN apk add --no-cache bash openssh socat && rm -rf /var/cache/apk/*

# Copy entrypoint script to container
COPY entry.sh /entry.sh
RUN chmod a+x /entry.sh

# Setup environment variables; export SSH_AUTH_SOCK from socket directory
ENV SOCKET_DIR /.ssh-agent
ENV SSH_AUTH_SOCK ${SOCKET_DIR}/ssh_auth_sock
ENV SSH_AUTH_PROXY_SOCK ${SOCKET_DIR}/ssh_auth_proxy_sock

# VOLUME ["${SOCKET_DIR}"]

ENTRYPOINT ["/entry.sh"]

CMD ["ssh-agent"]

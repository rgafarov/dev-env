FROM ubuntu:22.04

ARG UID
ARG GID
ARG SOCKET_DIR=/.ssh-agent

RUN apt update && apt -y install locales openssh-server socat && locale-gen en_US.UTF-8

# adding non root user(dev) and prepare dir for ssh socket
RUN groupadd -f --gid ${GID} dev && useradd --uid ${UID} --gid dev --shell /bin/bash --create-home dev && \
    mkdir -p ${SOCKET_DIR} && chown dev:dev ${SOCKET_DIR}

USER dev:dev

COPY --chown=dev:dev entry.sh /entry.sh

ENV SOCKET_DIR=${SOCKET_DIR}
ENV SSH_AUTH_SOCK ${SOCKET_DIR}/ssh_auth_sock
ENV SSH_AUTH_PROXY_SOCK ${SOCKET_DIR}/ssh_auth_proxy_sock

ENTRYPOINT ["/entry.sh"]

CMD ["ssh-agent"]

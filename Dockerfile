FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common \
        ca-certificates \
        gnupg \
    && add-apt-repository -y ppa:yuezk/globalprotect-openconnect \
    && apt-get update && apt-get install -y --no-install-recommends \
        globalprotect-openconnect \
        openssh-server \
        iproute2 \
        iputils-ping \
        dnsutils \
        sudo \
        iptables \
        procps \
        less \
        vim-tiny \
    && mkdir /var/run/sshd \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash -G sudo vpnuser \
    && echo 'vpnuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/vpnuser \
    && mkdir -p /home/vpnuser/.ssh \
    && chmod 700 /home/vpnuser/.ssh \
    && chown -R vpnuser:vpnuser /home/vpnuser/.ssh

RUN sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && echo 'AuthorizedKeysFile /home/vpnuser/.ssh/authorized_keys.real' >> /etc/ssh/sshd_config

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
CMD ["/entrypoint.sh"]

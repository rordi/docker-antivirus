FROM debian:jessie-slim
MAINTAINER Dietrich Rordorf <dr@ediqo.com>

USER root

# copy assets to image
COPY ./assets /usr/local

# install antivirus and dependencies, get the latest clamav and maldet signatures
RUN apt-get update && \
    apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools supervisor host tar wget chkconfig && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /var/log/cron && \
    cd /usr/local/ && chmod +x *.sh && sync && \
    cd /usr/local/bin && chmod +x *.sh && sync && \
    /usr/local/install_maldet.sh && \
    /usr/local/install_antivirus.sh && \
    apt-get -y remove curl apt-utils && \
    rm -rf /var/cache/* && \
    freshclam && \
    maldet -u -d

# export volumes (uncomment if you do not mount these volumes at runtime or via docker-compose)
# VOLUME /data/av/queue
# VOLUME /data/av/ok
# VOLUME /data/av/nok

ENTRYPOINT ["/usr/local/entrypoint.sh"]

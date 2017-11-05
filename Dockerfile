FROM debian:jessie-slim
MAINTAINER Dietrich Rordorf <dr@ediqo.com>

USER root

# copy assets to image
COPY ./assets /usr/local

# install antivirus and dependencies, get the latest clamav and maldet signatures
RUN apt-get update && \
    apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools tar wget chkconfig && \
    cd /usr/local/ && chmod +x *.sh && sync && ./install_maldet.sh && ./install_antivirus.sh && \
    cd /usr/local/bin && chmod +x *.sh && \
    apt-get -y remove curl apt-utils && \
    rm -rf /var/cache/* && \
    freshclam && \
    maldet -u -d

# export volumes (uncomment if you do not mount these volumes at runtime or via docker-compose)
# VOLUME /data/av/queue
# VOLUME /data/av/ok
# VOLUME /data/av/nok

# CMD will be substituted by docker run args, e.g. docker run -ti --name antivirus antivirus my@email.com
ENTRYPOINT ["/usr/local/entrypoint.sh"]
CMD [""]

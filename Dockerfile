FROM debian:jessie-slim

MAINTAINER Dietrich Rordorf <dr@ediqo.com>

USER root

COPY ./assets/install_maldet.sh /usr/local/install_maldet.sh
COPY ./assets/conf.maldet /usr/local/maldetect/conf.maldet
COPY ./assets/entrypoint.sh /usr/local/entrypoint.sh
COPY ./assets/install_antivirus.sh /usr/local/install_antivirus.sh
COPY ./assets/install_alerts.sh /usr/local/install_alerts.sh
COPY ./assets/scanfile.sh /usr/local/sbin/scanfile
COPY ./assets/scanner.sh /usr/local/sbin/scanner

# install antivirus and other tools we need
RUN apt-get update && \
    apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools tar wget && \
    cd /usr/local/ && chmod +x ./install_maldet.sh && ./install_maldet.sh && \
    chmod +x /usr/local/entrypoint.sh && \
    cd /usr/local/ && chmod +x ./install_alerts.sh && \
    cd /usr/local/ && chmod +x ./install_antivirus.sh && ./install_antivirus.sh && \
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

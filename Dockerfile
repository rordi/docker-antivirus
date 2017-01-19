FROM debian:jessie-slim

MAINTAINER Dietrich Rordorf <dr@ediqo.com>

USER root

# install antivirus and other tools we need
RUN apt-get update
RUN apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools tar wget

# install Linux Malware Detection (LMD)
COPY ./assets/install_maldet.sh /usr/local/install_maldet.sh
RUN cd /usr/local/ && chmod +x ./install_maldet.sh && ./install_maldet.sh
COPY ./assets/conf.maldet /usr/local/maldetect/conf.maldet

# copy entrypoint script
COPY ./assets/entrypoint.sh /usr/local/entrypoint.sh
RUN chmod +x /usr/local/entrypoint.sh

# configure antivirus solution
COPY ./assets/install_antivirus.sh /usr/local/install_antivirus.sh
COPY ./assets/scanfile.sh /usr/local/sbin/scanfile
COPY ./assets/scanner.sh /usr/local/sbin/scanner
RUN cd /usr/local/ && chmod +x ./install_antivirus.sh && ./install_antivirus.sh

# remove tools we no longer need
RUN apt-get -y remove curl apt-utils
RUN rm -rf /var/cache/*

# export volumes
VOLUME /data/queue
VOLUME /data/ok
VOLUME /data/nok

# CMD will be substituted by docker run args, e.g. docker run -ti --name antivirus antivirus my@email.com
ENTRYPOINT ["/usr/local/entrypoint.sh"]
CMD [""]

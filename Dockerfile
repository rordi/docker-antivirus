FROM debian:jessie

MAINTAINER Dietrich Rordorf <dr@ediqo.com>

USER root

RUN apt-get update
RUN apt-get install -y apt-utils clamav clamav-daemon curl inotify-tools tar wget

RUN mkdir -p /tmp/maldetect-current
RUN cd /tmp && curl -S -L -O http://www.rfxn.com/downloads/maldetect-current.tar.gz
RUN tar -xzvf /tmp/maldetect-current.tar.gz -C /tmp/maldetect-current
RUN rm /tmp/maldetect-current.tar.gz
RUN cd /tmp/maldetect-current/maldetect-1.5 && ./install.sh
RUN ln -s /usr/local/maldetect/maldet /bin/maldet
RUN hash -r

COPY ./assets/conf.maldet /usr/local/maldetect/conf.maldet
COPY ./assets/entrypoint.sh /usr/local/entrypoint.sh
RUN chmod +x /usr/local/entrypoint.sh

# Exposed port/s
#EXPOSE 1234

# Expose volume/s
#VOLUME /data

# Start AV daemons
# ...

# CMD will be substituted by docker run args, e.g. docker run antivirus 1 my@email.com
ENTRYPOINT ["/usr/local/entrypoint.sh"]
CMD ["0", ""]

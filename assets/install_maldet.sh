#!/bin/sh
mkdir -p /tmp/maldetect-current
cd /tmp
curl -S -L -O http://www.rfxn.com/downloads/maldetect-current.tar.gz && \
# tar contains a folder like maldetect-1.6.2
tar -xzvf /tmp/maldetect-current.tar.gz -C /tmp/maldetect-current
cd ./maldetect-current
maldetversion=$(ls -d */ | grep maldetect)
# run install with bash to support advanced operators
cd $maldetversion && bash ./install.sh
ln -s /usr/local/maldetect/maldet /bin/maldet
hash -r
yes | rm -R /tmp/maldetect-current

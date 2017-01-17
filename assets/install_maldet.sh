#!/bin/sh
mkdir -p /tmp/maldetect-current
cd /tmp && curl -S -L -O http://www.rfxn.com/downloads/maldetect-current.tar.gz
tar -xzvf /tmp/maldetect-current.tar.gz -C /tmp/maldetect-current
rm /tmp/maldetect-current.tar.gz
cd /tmp/maldetect-current/maldetect-1.5 && ./install.sh
ln -s /usr/local/maldetect/maldet /bin/maldet
hash -r

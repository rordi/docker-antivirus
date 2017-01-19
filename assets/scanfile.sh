#!/bin/bash
now=`date +'%Y-%m-%d %T'`
echo -n "[${now}]"
echo -n " "

# scan with ClamAV first (faster)
clamscan -rio --quiet --enable-stats --move /data/quarantine /data/scan

# scan with maldet second, if file still in /data/scan
files=$(shopt -s nullglob dotglob; echo /usr/local/maldetect/quarantine/*)
if (( ${#files} ))
then
    maldet -a /data/scan/
fi

# maldet quarantines into /usr/local/maldetect/quarantine, move to /data/quarantine
files=$(shopt -s nullglob dotglob; echo /usr/local/maldetect/quarantine/*)
if (( ${#files} ))
then
    for file in "/usr/local/maldetect/quarantine"/* ; do
        filename=`basename $file`
        echo "Moving maldet quarantined file to /data/quarantine/${filename}"
        mv -f $file "/data/quarantine/${filename}"
    done
fi

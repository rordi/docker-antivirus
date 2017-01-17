#!/bin/bash
now=`date +'%Y-%m-%d %T'`
echo -n "[${now}]"
echo -n " "

# scan with maldet first
maldet -a /data/scan/

# maldet quarantines into /usr/local/maldetect/quarantine, move to /data/quarantine
files=$(shopt -s nullglob dotglob; echo /usr/local/maldetect/quarantine/*)
if (( ${#files} ))
then
    for file in "/usr/local/maldetect/quarantine"/* ; do
        filename=`basename $file`
        echo "Moving maldet quarantined file to /data/quarantine/${filename}"
        mv $file "/data/quarantine/${filename}"
    done
fi

# additionally, scan with ClamAV
clamscan -rio --quiet --enable-stats --move /data/quarantine /data/scan

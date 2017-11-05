#!/bin/bash
now=`date +'%Y-%m-%d %T'`
printf "[${now}]\n"

# scan with ClamAV first (faster)
clamscan -rio --enable-stats --move /data/av/quarantine /data/av/scan

# scan with maldet second, if file still in /data/av/scan
files=$(shopt -s nullglob dotglob; echo /data/av/scan/*)
if (( ${#files} ))
then
    maldet -a /data/av/scan/
fi

# maldet quarantines into /usr/local/maldetect/quarantine, move to /data/av/quarantine
files=$(shopt -s nullglob dotglob; echo /usr/local/maldetect/quarantine/*)
if (( ${#files} ))
then
    for file in "/usr/local/maldetect/quarantine"/* ; do
        filename=`basename $file`
        printf "  --> Moving maldet quarantined file to /data/av/quarantine/${filename}\n"
        mv -f $file "/data/av/quarantine/${filename}"
    done
fi

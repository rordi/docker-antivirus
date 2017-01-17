#!/bin/bash
# scan with maldet first
maldet -a /data/scan
# maldet quarantines into /usr/local/maldetect/quarantine, move to /data/quarantine
for file in "/usr/local/maldetect/quarantine"/* ; do
    filename=`basename $file`
    echo "Moving maldet quarantined file to /data/quarantine/${filename}"
    mv $file "/data/quarantine/${filename}"
done
# additionally, scan with ClamAV
clamscan -rio --quiet --move /data/quarantine /data/scan

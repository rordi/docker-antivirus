#!/bin/bash
for file in "/data/queue"/* ; do
    echo "Processing ${file}"
    filename=`basename $file`
    mv $file "/data/scan/${filename}"
    scanfile "/data/scan/${filename}"
    if [ -e "/data/scan/${filename}" ]
    then
        mv "/data/scan/${filename}" "/data/ok/${filename}"
        if [ -e "/data/quarantine/${filename}" ]
        then
            hash=`md5sum "/data/quarantine/${filename}"``
            mv "/data/quarantine/${filename}" "/data/quarantine/${hash}"
            mv /data/scan/info "/data/nok/${hash}"
        fi
    fi
done

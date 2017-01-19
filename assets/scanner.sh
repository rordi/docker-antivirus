#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/queue/*)
if (( ${#files} ))
then
    printf "\nFound files to process"
    for file in "/data/queue"/* ; do
        filename=`basename $file`
        mv -f $file "/data/scan/${filename}"
        printf "\nProcessing /data/scan/${filename}"
        scanfile > /data/scan/info 2>&1
        if [ -e "/data/scan/${filename}" ]
        then
            printf "\n  --> File ok"
            mv -f "/data/scan/${filename}" "/data/ok/${filename}"
            printf "\n  --> File moved to /data/ok/${filename}"
            rm /data/scan/info
        elif [ -e "/data/quarantine/${filename}" ]
        then
            printf "\n  --> File quarantined / nok"
            hash=`md5sum "/data/quarantine/${filename}" | awk '{ print $1 }'`
            mv -f "/data/quarantine/${filename}" "/data/quarantine/${hash}"
            printf "\n  --> File moved to /data/quarantine/${hash}"
            mv -f "/data/scan/info" "/data/nok/${hash}"
            printf "\n  --> Scan report moved to /data/nok/${hash}"
        fi
    done
    printf "\nDone with processing\n"
fi

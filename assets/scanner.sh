#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/queue/*)
if (( ${#files} ))
then
    printf "\nFound files to process\n"
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
            mv -f "/data/quarantine/${filename}" "/data/quarantine/${filename}"
            printf "\n  --> File moved to /data/quarantine/${filename}"
            mv -f "/data/scan/info" "/data/nok/${filename}"
            printf "\n  --> Scan report moved to /data/nok/${filename}"
        fi
    done
    printf "\nDone with processing\n"
fi

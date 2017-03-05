#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/queue/*)
if (( ${#files} ))
then
    echo -n "Found files to process\n"
    for file in "/data/queue"/* ; do
        filename=`basename $file`
        mv -f $file "/data/scan/${filename}"
        echo -n "Processing /data/scan/${filename}"
        scanfile > /data/scan/info 2>&1
        if [ -e "/data/scan/${filename}" ]
        then
            echo -n "  --> File ok"
            mv -f "/data/scan/${filename}" "/data/ok/${filename}"
            echo -n "  --> File moved to /data/ok/${filename}"
            rm /data/scan/info
        elif [ -e "/data/quarantine/${filename}" ]
        then
            echo -n "  --> File quarantined / nok"
            mv -f "/data/scan/info" "/data/nok/${filename}"
            echo -n "  --> Scan report moved to /data/nok/${filename}"
        fi
    done
    echo -n "Done with processing"
fi

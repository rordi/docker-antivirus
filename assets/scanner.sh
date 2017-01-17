#!/bin/sh
for filename in /data/queue; do
    mv /data/queue/$filename /data/scan
    scanfile
    if [ -e /data/scan/$filename ]
    then
        mv /data/scan/$filename /data/ok
        if [ -e /data/quarantine/$filename ]
        then
            hash="$(md5 /data/quarantine/${filename})"
            mv /data/quarantine/$filename /data/quarantine/$hash
            mv /data/scan/log /data/nok/$hash
        fi
    fi
done

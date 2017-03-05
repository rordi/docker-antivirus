#!/bin/bash
echo -n "Updating antivirus configuration ..."
sed -i -e "s/{ALERT}/0/g" /usr/local/maldetect/conf.maldet
sed -i -e "s/{EMAIL}//g" /usr/local/maldetect/conf.maldet
if [[ $# -eq 1 && $1 = *[!\ ]* ]] ; then
    email=$1
    /usr/local/install_alerts.sh $email
fi
echo -n "Done"

PATHS=(/data/scan /data/quarantine /data/queue /data/ok /data/nok)
for i in ${PATHS[@]}; do
    mkdir -p ${i}
done

echo -n "Fetching latest ClamAV virus definitions"
freshclam

echo -n "Fetching latest Maldet malware signatures"
maldet -u -d

# inotify watches the queue and launches the AV scanner when new files are written, keeps the docker container running as well!
#
#  -m /data/queue                monitor /data/queue forever
#  -r                            watched directory recursively
#  -q                            quiet (only print events)
#  -t 0                          never timeout
#  -e moved_to,close_write       only fire if a file is moved to or written into the watched directory
#
echo -n "Waiting for changes to /data/queue ..."
inotifywait -m -r -q -t 0 -e moved_to,close_write /data/queue |
while read -r path action file; do
     scanner
done

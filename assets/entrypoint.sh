#!/bin/bash
printf "Updating antivirus configuration ...\n"
sed -i -e "s/{ALERT}/0/g" /usr/local/maldetect/conf.maldet
sed -i -e "s/{EMAIL}//g" /usr/local/maldetect/conf.maldet
if [[ $# -eq 1 && $1 = *[!\ ]* ]] ; then
    email=$1
    /usr/local/install_alerts.sh $email
fi
printf "Done\n"

PATHS=(/data/av/scan /data/av/quarantine /data/av/queue /data/av/ok /data/av/nok)
for i in ${PATHS[@]}; do
    mkdir -p ${i}
done

printf "Fetching latest ClamAV virus definitions\n"
freshclam

printf "Fetching latest Maldet malware signatures\n"
maldet -u -d

# inotify watches the queue and launches the AV scanner when new files are written, keeps the docker container running as well!
#
#  -m /data/av/queue                monitor /data/av/queue forever
#  -r                            watched directory recursively
#  -q                            quiet (only print events)
#  -t 0                          never timeout
#  -e moved_to,close_write       only fire if a file is moved to or written into the watched directory
#
printf "Waiting for changes to /data/av/queue ...\n"
inotifywait -m -r -q -t 0 -e moved_to,close_write /data/av/queue |
while read -r path action file; do
     scanner
done

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

# printf "Fetching latest ClamAV virus definitions ...\n"
# freshclam

# printf "Fetching latest Maldet malware signatures ...\n"
# maldet -u -d

# start supervisors, which spawns cron and inotify launcher
# printf "Starting supervisord ...\n"
/usr/bin/supervisord -c /usr/local/supervisor.conf

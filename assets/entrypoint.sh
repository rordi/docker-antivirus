#!/bin/bash
echo "Updating antivirus configuration..."
sed -i -e "s/{ALERT}/0/g" /usr/local/maldetect/conf.maldet
sed -i -e "s/{EMAIL}//g" /usr/local/maldetect/conf.maldet
if [[ $# -eq 1 && $1 = *[!\ ]* ]] ; then
    email=$1
    /usr/local/install_alerts.sh $email
fi
echo "Done"

PATHS=(/data/scan /data/quarantine /data/queue /data/ok /data/nok)
for i in ${PATHS[@]}; do
    mkdir -p ${i}
done

# keep the docker container running
tail -f /dev/null

#!/bin/bash
if [[ $# -eq 1 && $1 = *[!\ ]* ]] ; then
    email=$1
    sed -i -e "s/email_alert=\"0\"/email_alert=\"1\"/g" /usr/local/maldetect/conf.maldet
    sed -i -e "s/email_addr=\"\"/email_addr=\"${email}\"/g" /usr/local/maldetect/conf.maldet
    echo -n "Enbaled email alerts for ${email}"
fi

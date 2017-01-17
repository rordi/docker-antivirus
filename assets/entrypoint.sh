#!/bin/bash
echo "Updating antivirus configuration..."
sed -i -e "s/{ALERT}/0/g" /usr/local/maldetect/conf.maldet
sed -i -e "s/{EMAIL}//g" /usr/local/maldetect/conf.maldet
if [[ $# -eq 1 && $1 = *[!\ ]* ]] ; then
    email=$1
    sed -i -e "s/{ALERT}/1/g" /usr/local/maldetect/conf.maldet
    sed -i -e "s/{EMAIL}/${email}/g" /usr/local/maldetect/conf.maldet
    echo " -> enbaled email alerts for ${email}"
else
    sed -i -e "s/{ALERT}/0/g" /usr/local/maldetect/conf.maldet
    sed -i -e "s/{EMAIL}//g" /usr/local/maldetect/conf.maldet
fi
echo "Done"

/bin/bash -l

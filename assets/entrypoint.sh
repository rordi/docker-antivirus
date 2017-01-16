#!/bin/sh
if [ $# -ne 2 ]
then
    echo "Usage: `basename $0`   alerts [0/1]   email [email address]"
    exit 1
fi

alert=$1
email=$2
sed -i -e "s/{ALERT}/${alert}/g" /usr/local/maldetect/conf.maldet
sed -i -e "s/{EMAIL}/${email}/g" /usr/local/maldetect/conf.maldet

/bin/bash -l

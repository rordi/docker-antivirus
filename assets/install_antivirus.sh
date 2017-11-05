#!/bin/sh

# setup cron to update virus signatures hourly
cd /usr/local
crontab -l > tempcrons
echo "5,15,25,35,45,55 * * * * /usr/bin/freshclam >> /var/log/cron/general.log 2>&1" >> tempcrons
echo "1,11,21,31,41,51 * * * * /usr/local/sbin/maldet -u -d >> /var/log/cron/general.log 2>&1" >> tempcrons
crontab tempcrons
rm tempcrons

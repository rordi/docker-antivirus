#!/bin/sh

# setup directories that are to be exposed as volumes
mkdir -p /data/queue
mkdir -p /data/scan
mkdir -p /data/ok
mkdir -p /data/nok
mkdir -p /data/quarantine

# setup cron to update virus signatures hourly
cd /usr/local
crontab -l > tempcrons
echo "05 * * * * freshclam --quiet" >> tempcrons
crontab tempcrons
rm tempcrons

# make scanfile and scanner executable
chmod +x /usr/local/sbin/scanfile
chmod +x /usr/local/sbin/scanner

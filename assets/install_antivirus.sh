#!/bin/sh

# setup directories that are to be exposed as volumes
mkdir -p /data/av/queue
mkdir -p /data/av/scan
mkdir -p /data/av/ok
mkdir -p /data/av/nok
mkdir -p /data/av/quarantine

# setup cron to update virus signatures hourly
cd /usr/local
crontab -l > tempcrons
echo "05 * * * * freshclam" >> tempcrons
echo "10 * * * * maldet -u -d" >> tempcrons
crontab tempcrons
rm tempcrons

# make scanfile and scanner executable
chmod +x /usr/local/sbin/scanfile
chmod +x /usr/local/sbin/scanner

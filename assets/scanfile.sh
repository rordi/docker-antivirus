#!/bin/bash
clamscan -rio --quiet --move /data/quarantine /data/scan > /data/scan/info 2>&1

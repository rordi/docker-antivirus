# docker-antivirus


#### Notes

 - work in progress as of 17.01.2017
 - the image is maintained by Dietrich Rordorf, [Ediqo](https://www.ediqo.com/)
 - the image was prepared for [IWF](http://www.iwf.ch/web-solutions/)
 - you can contribute to this project at https://github.com/rordi/docker-antivirus



### Introduction

Build for [dro0/docker-antivirus](https://hub.docker.com/r/dro0/docker-antivirus/)
Docker image running [Linux Malware Detect (LMD)](https://github.com/rfxn/linux-malware-detect)
with [ClamAV](https://github.com/vrtadmin/clamav-devel) as the scanner.

dro0/docker-antivirus provides a plug-in container to e.g. scan file uploads in
web applications before further processing.

The container exposes volume mounts to push files to be checked into the container
, to fetch checked files (no virus/malware detected), and to fetch the scan reports
for files where a virus/malware was found.

The container auto-updates the LMD and ClamAV virus signatures once per day.

Optionally, an email alert can be sent to a specified email address whenever a
virus/malware is detected in a file.


### Volume mounts

        /data/queue         --> push files to be checked here
        /data/ok            --> fetch checked files from here
        /data/nok           --> provides scan reports for quanrantined files
        /data/quarantine    --> quarantine files can be accessed here (e.g. to delete)



### Docker Pull & Run

To install the container, pull it from the Docker registry (latest tag refers to
the master branch, use dev tag for dev branch):

    docker pull dro0/docker-antivirus:latest

    docker run -tid --name docker-antivirus dro0/docker-antivirus



### Docker Build & Run

To build your own image, clone the repo and cd into the clonde repository root
folder. Then, build as follows:

    docker build -t docker-antivirus .

To start the built image, run the following command. Optionally pass an email
address to activate email alerts when a virus/malware is detected:

    docker run -tid --name docker-antivirus docker-antivirus:latest [your@email.com]

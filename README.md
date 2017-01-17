# docker-antivirus

(Work in progress as of 17.01.2017)

### Introduction

Build for dro0/docker-antivirus Docker image including Linux Malware Detect (LMD) and ClamAV.

dro0/docker-antivirus provides a plug-in container to e.g. scan file uploads in web applications before further processing.

The container exposes volume mounts to push files to be checked into the container, to fetch checked files (no virus/malware detected), and to fetch the scan reports for files where a virus/malware was found.

The container auto-updates the LMD and ClamAV virus signatures once per day.

Optionally, an email alert can be sent to a specified email address whenever a virus/malware is detected in a file.

### Volume mounts

        /data/queue         --> push files to be checked here
        /data/ok            --> fetch checked files from here
        /data/nok           --> provides scan reports for quanrantined files
        /data/quarantine    --> quarantine files can be accessed here (e.g. to delete)

### Docker Pull & Run

To install the container, pull it from the Docker registry (latest tag refers to the master branch, use dev tag for dev branch):

    docker pull dro0/docker-antivirus:latest
  
    docker run -tid --name docker-antivirus dro0/docker-antivirus


### Docker Build & Run

To build your own image, clone the repo and cd into the clonde repository root folder. Then, build as follows:

    docker build -t docker-antivirus .
  
To start the built image, run:

    docker run -tid --name docker-antivirus docker-antivirus:latest


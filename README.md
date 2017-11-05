# docker-antivirus

[![](https://images.microbadger.com/badges/image/rordi/docker-antivirus.svg)](https://microbadger.com/images/rordi/docker-antivirus "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/rordi/docker-antivirus.svg)](https://microbadger.com/images/rordi/docker-antivirus "Get your own version badge on microbadger.com")

### Notes
- the image is maintained by Dietrich Rordorf, [Ediqo](https://www.ediqo.com/)
- initially the Dockerfile was prepared for [IWF](http://www.iwf.ch/web-solutions/)
- you can contribute to this project at https://github.com/rordi/docker-antivirus

#### Version 2
- released 06.11.2017
- use supervisord as main command, spawning inotify and cron as subprocesses
- refactor assets folder structure to reduce number of layers in resulting Docker image

#### Version 1
 - released 19.01.2017
 - first stable build

### Quick start

If you simply want to try out the setup, copy the docker-compose.yml file from the [repository](https://github.com/rordi/docker-antivirus) to your local file system and run:

    docker-compose up -d


### Introduction

Build for [rordi/docker-antivirus](https://hub.docker.com/r/rordi/docker-antivirus/) Docker image running [Linux Malware Detect (LMD)](https://github.com/rfxn/linux-malware-detect) with [ClamAV](https://github.com/vrtadmin/clamav-devel) as the scanner.

rordi/docker-antivirus provides a plug-in container to e.g. scan file uploads in web applications before further processing.

The container requires three volume mounts from where to take files to scan, and to deliver back scanned files and scan reports.

The container auto-updates the LMD and ClamAV virus signatures once per hour.

Optionally, an email alert can be sent to a specified email address whenever a virus/malware is detected in a file.


### Required volume mounts

Please provide the following volume mounts at runtime (e.g. in your docker-compose file). The antivirus container expects the following paths to be present when running:

        /data/av/queue         --> files to be checked
        /data/av/ok            --> checked files (ok)
        /data/av/nok           --> scan reports for infected files

Additionally, you may mount the quarantine folder and provide it to the antivirus container at the following path (this might be useful if you want to process the quarantined files from another container):

        /data/av/quarantine    --> quarantined files



### Docker Pull & Run

To install the container, pull it from the Docker registry (latest tag refers to
the master branch, use dev tag for dev branch):

    docker pull rordi/docker-antivirus:latest

To run the docker container, use the following command. If you pass an email address as the last argument, email alerts will be activated and sent to this email address whenever a virus is detected.

    docker run -tid --name docker-antivirus rordi/docker-antivirus [email@example.net]


### Docker Build & Run

To build your own image, clone the repo and cd into the cloned repository root folder. Then, build as follows:

    docker build -t docker-antivirus .

To start the built image, run the following command. Optionally pass an email address to activate email alerts when a virus/malware is detected:

    docker run -tid --name docker-antivirus docker-antivirus:latest [email@example.net]


### Testing

You can use the [EICAR test file](https://en.wikipedia.org/wiki/EICAR_test_file) to test the AV setup.


### Mounting volumes with docker-compose

Here is an exmple entry that you can use in your docker-compose file to easily plug in the container into your existing network. Replace "networkid" with your actual netwerk id. Optionally turn on email alerts by uncommenting the "command". Finally, make sure the ./data/av/... folders exist on your local/host system or change the paths.


    docker-av:
      image: rordi/docker-antivirus
      container_name: docker-av
      # uncomment and set the email address to receive email alerts when viruses are detected
      #command:
      # - /usr/local/install_alerts.sh email@example.net
      volumes:
        - ./data/queue:/data/av/queue
        - ./data/ok:/data/av/ok
        - ./data/nok:/data/av/nok
      networks:
        - yournetworkid

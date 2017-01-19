# docker-antivirus


#### Notes

 - first stable release 19.01.2017
 - the image is maintained by Dietrich Rordorf, [Ediqo](https://www.ediqo.com/)
 - the image was prepared for [IWF](http://www.iwf.ch/web-solutions/)
 - you can contribute to this project at https://github.com/rordi/docker-antivirus



### Introduction

Build for [dro0/docker-antivirus](https://hub.docker.com/r/dro0/docker-antivirus/) Docker image running [Linux Malware Detect (LMD)](https://github.com/rfxn/linux-malware-detect) with [ClamAV](https://github.com/vrtadmin/clamav-devel) as the scanner.

dro0/docker-antivirus provides a plug-in container to e.g. scan file uploads in web applications before further processing.

The container requires three volume mounts from where to take files to scan, and to deliver back scanned files and scan reports. 

The container auto-updates the LMD and ClamAV virus signatures once per hour.

Optionally, an email alert can be sent to a specified email address whenever a virus/malware is detected in a file.


### Required volume mounts

Please provide the following volume mounts at runtime (e.g. in your docker-compose file). The antivirus container expects the following paths to be present when running:

        /data/queue         --> files to be checked
        /data/ok            --> checked files (ok)
        /data/nok           --> scan reports for infected files
        
Additionally, you may mount the quarantine folder and provide it to the antivirus container at the following path (this might be useful if you want to process the quarantined files from another container): 

        /data/quarantine    --> quarantined files



### Docker Pull & Run

To install the container, pull it from the Docker registry (latest tag refers to
the master branch, use dev tag for dev branch):

    docker pull dro0/docker-antivirus:latest

To run the docker container, use the following command. If you pass an email address as the last argument, email alerts will be activated and sent to this email address whenever a virus is detected.

    docker run -tid --name docker-antivirus dro0/docker-antivirus [email@example.net]



### Docker Build & Run

To build your own image, clone the repo and cd into the clonde repository root folder. Then, build as follows:

    docker build -t docker-antivirus .

To start the built image, run the following command. Optionally pass an email address to activate email alerts when a virus/malware is detected:

    docker run -tid --name docker-antivirus docker-antivirus:latest [email@example.net]



### Mounting volumes with docker-compose

Here is an exmple entry that you can use in your docker-compose file to easily plug in the container into your existing network. Replace "networkid" with your actual netwerk id. Optionally turn on email alerts by uncommenting the "command". Finally, make sure the ./data/... folders exist on your local/host system or change the paths.


    docker-av:
      image: dro0/docker-antivirus
      container_name: docker-av
      # uncomment and set the email address to receive email alerts when viruses are detected
      #command:
      # - /usr/local/install_alerts.sh email@example.net
      volumes:
        - ./data/queue:/data/queue
        - ./data/ok:/data/ok
        - ./data/nok:/data/nok
      networks:
        - yournetworkid

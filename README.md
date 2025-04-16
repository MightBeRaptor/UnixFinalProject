# UnixFinalProject
Final Project for System Administration using Unix Class utilizing GCP and Docker

## Setup
This is designed to be ran on a Google Cloud Platform (GCP) ubuntu Virtual Machine. Functionality may or may not differ when ran locally.
1. Clone this repository with `git clone git@github.com:MightBeRaptor/UnixFinalProject.git`
2. Run `cd UnixFinalProject` to open the git repository's directory
3. Run `scripts/setup.sh` which will install all dependencies (Docker, LVM) and launch docker
4. Run `scripts/launch.sh` which will compose down existing containers (if previously ran) and compose up 3 copies of the application.
5. Open url `<vm's-external-ip>` in your favorite browser
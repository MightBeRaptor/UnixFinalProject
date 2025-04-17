# UnixFinalProject
Final Project for System Administration using Unix Class utilizing GCP and Docker

## Setup
This is designed to be ran on a Google Cloud Platform (GCP) ubuntu Virtual Machine. Functionality may or may not differ when ran locally.

1. Clone this repository with `git clone git@github.com:MightBeRaptor/UnixFinalProject.git`
2. Run `cd UnixFinalProject` to open the git repository's directory
3. Run `bash src/scripts/setup.sh` which will install all dependencies (Docker, LVM) and launch docker
4. Run `bash src/scripts/launch.sh` which will compose down existing containers (if previously ran) and compose up 3 copies of the application
5. Open url `<vm's-external-ip>` in your favorite browser
6. When ready, run `bash src/scripts/add_crontab.sh` to start autoscaling from 3 to 6 replicas depending on the CPU %


## Utilities
* Run `sudo grep CRON /var/log/syslog` to confirm the crontab ran both `get_metrics.sh` and `scale.sh`
* Run `cat /var/mail/your-username` to read any error messages that were mailed to you
* Run `cat data/metrics.txt` to view the CPU (%) last detected
* Run `bash src/scripts/remove_crontab.sh` to remove the existing crontab and stop autoscaling
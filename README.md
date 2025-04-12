# UnixFinalProject
Final Project for System Administration using Unix Class utilizing GCP and Docker

## Setup
1. Install and launch [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Run `docker-compose up --build --scale web=3` or add the 'Docker' and 'Dev Containers' extensions to Visual Studio Code, right click `docker-compose.yml` and select `Compose Up`
3. Open `localhost:80` in your favorite browser

## Launching on the GCP Network
1. Run `cd UnixFinalProject` to open the project
2. Run `git pull` to pull the newest version
3. Run `docker-compose up --build --scale web=3` to launch the website
4. Open website via the GCP VM's External IP Address
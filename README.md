[![Docker Automated build](https://img.shields.io/docker/automated/s1lvester/docker-snapcast-multiroomaudio.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/s1lvester/docker-snapcast-multiroomaudio.svg)]()

# docker-snapcast-multiroomaudio
Just a simple docker-container to run snapcast (snapserver) with Spotify and AirPlay Streaming options. Uses Avahi for service announcements and uses macvlan to be addressable to native snapclients.

# Usage:
Either edit the docker-compose.yml and add your spotify username and password (yes - in cleartext), or do so in the Makefile.

# Networking:
This container assumes that you have a macvlan going. If you need help setting one up, just edit the Makefile to your liking and `sudo make lan`. 


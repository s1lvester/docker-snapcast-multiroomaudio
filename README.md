[![Docker Automated build](https://img.shields.io/docker/automated/s1lvester/docker-snapcast-multiroomaudio.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/s1lvester/docker-snapcast-multiroomaudio.svg)]()

# docker-snapcast-multiroomaudio
Simple docker-container to run [snapcast](https://github.com/badaix/snapcast) (snapserver) with Spotify (via [librespot](https://github.com/plietar/librespot)) and AirPlay (via [shairport-sync](https://github.com/mikebrady/shairport-sync)) Streaming options. Uses Avahi for service announcements and uses macvlan to be addressable to native snapclients on your LAN. So this is the definition of "standing on the shoulders of giants"

# PLEASE NOTICE
If you're reading this on (https://hub.docker.com) or (https://store.docker.com): I'm using the docker-services here just as a glorified "build-service". This project lives on [github](https://github.com/s1lvester/docker-snapcast-multiroomaudio), so Issues should be brought up there.

# Usage:
I recommend you use the docker-compose.yml. 

# Networking:
This container assumes that you have a macvlan (named "mylan" - but you're free to change that of course) going. If you need help setting one up, just edit the Makefile to your liking and `sudo make lan`. 

# Why macvlan?
Snapcast, by default, uses mdns for service announcement. This actually works really well, but in our case the mdns announcement would just point to the docker-host. This is fine as long as you have no other containers running that also try to announce their services. Then you either have to announce from one dedicated "mdns-container" or via the dockerhost itself (or at least that's what I experienced - correct me if I'm wrong). This makes thinks overly complicated, so a dedicated IP on the host-lan seemed less of a hassle.

# Trivia
I'm currently building a seperate version of librespot with enabled pipe-backend to push directly into snapcast. I also ripped out rust-mdns since we're using avahi already.

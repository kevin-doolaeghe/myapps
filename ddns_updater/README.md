# DDNS-Updater - DDNS management

:triangular_flag_on_post: Setup the **DDNS-Updater** DDNS management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml ddns_updater
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [GitHub repository](https://github.com/qdm12/ddns-updater)
* [Docker Hub image](https://hub.docker.com/r/qmcgaw/ddns-updater)

# Duck DNS DDNS service

:triangular_flag_on_post: Setup the **Duck DNS** DDNS stack.

## Author

**Kevin Doolaeghe**

## Setup

```
docker stack deploy -c docker-compose.yml duckdns
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## References

* [Duck DNS website](https://www.duckdns.org/)
* [Duck DNS image on Docker Hub](https://hub.docker.com/r/linuxserver/duckdns)

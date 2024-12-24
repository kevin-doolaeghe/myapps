# Duck DNS

:triangular_flag_on_post: **Duck DNS** application package.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml -p duckdns
```

:warning: This program require a docker instance with **Swarm** mode enabled to be executed.

## Configuration

Change the settings in the `.env` file to configure the Duck DNS DDNS service.

## References

* [Duck DNS website](https://www.duckdns.org/)
* [Duck DNS for Docker - DDNS service](https://hub.docker.com/r/linuxserver/duckdns)

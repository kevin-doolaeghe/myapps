# Traefik reverse-proxy

:triangular_flag_on_post: Setup the **Traefik** reverse-proxy stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml traefik
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## References

* [Traefik website](https://traefik.io/)
* [Traefik repository on Github](https://github.com/traefik/traefik)
* [Traefik image on Docker Hub](https://hub.docker.com/_/traefik)

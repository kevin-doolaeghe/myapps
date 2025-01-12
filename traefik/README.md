# Traefik - Reverse-proxy

:triangular_flag_on_post: Setup the **Traefik** reverse-proxy stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml traefik
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Offical website](https://traefik.io/)
* [GitHub repository](https://github.com/traefik/traefik)
* [Docker Hub image](https://hub.docker.com/_/traefik)

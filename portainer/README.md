# Portainer - Container management

:triangular_flag_on_post: Setup the **Portainer** container management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml portainer
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://www.portainer.io/)
* [GitHub repository](https://github.com/portainer/portainer)
* [Docker Hub image](https://hub.docker.com/r/portainer/portainer)

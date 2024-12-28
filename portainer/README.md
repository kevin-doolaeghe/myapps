# Portainer

:triangular_flag_on_post: Setup the **Portainer** stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml portainer
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## Web access

Portainer's web interface is accessible via port `9443` (HTTPS).

:key: Default credentials :
* Email address : `admin`
* Password : :no_entry_sign:

## References

* [Portainer website](https://www.portainer.io/)
* [Portainer repository on Github](https://github.com/portainer/portainer)
* [Portainer image on Docker Hub](https://hub.docker.com/r/portainer/portainer)

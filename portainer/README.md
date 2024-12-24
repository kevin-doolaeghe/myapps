# Portainer

:triangular_flag_on_post: **Portainer** application package.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml -p portainer
```

:warning: This program require a docker instance with **Swarm** mode enabled to be executed.

## Web access

Portainer's web interface is accessible via port `9443` (HTTPS).

:key: Default credentials :
* Email address : `admin`
* Password : :no_entry_sign:

## References

* [Portainer website](https://www.portainer.io/)

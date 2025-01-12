# Guacamole - Remote desktop management

:triangular_flag_on_post: Setup the **Guacamole** remote desktop management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml guacamole
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://guacamole.apache.org/)
* [Docker Hub image](https://hub.docker.com/r/guacamole/guacamole)

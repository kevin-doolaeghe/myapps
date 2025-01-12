# PGAdmin - PostgreSQL database management

:triangular_flag_on_post: Setup the **PGAdmin** PostgreSQL database management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml pgadmin
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://www.pgadmin.org/)
* [GitHub repository](https://github.com/pgadmin-org/pgadmin4)
* [Docker Hub image](https://hub.docker.com/r/dpage/pgadmin4)

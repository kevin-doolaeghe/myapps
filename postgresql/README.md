# PostgreSQL - Data storage

:triangular_flag_on_post: Setup the **PostgreSQL** data storage stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml postgresql
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://www.postgresql.org/)
* [GitHub repository](https://github.com/postgres/postgres)
* [Docker Hub image](https://hub.docker.com/_/postgres)

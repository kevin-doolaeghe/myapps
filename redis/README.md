# Redis - Data caching

:triangular_flag_on_post: Setup the **Redis** data caching stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml redis
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://redis.io/)
* [GitHub repository](https://github.com/redis/redis)
* [Docker Hub image](https://hub.docker.com/_/redis)

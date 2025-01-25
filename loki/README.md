# Loki - Monitoring

:triangular_flag_on_post: Setup the **Loki** monitoring stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml loki
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://grafana.com/oss/loki/)
* [GitHub repository](https://github.com/grafana/loki)
* [Docker Hub image](https://hub.docker.com/r/grafana/loki)

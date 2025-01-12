# Prometheus - Data monitoring

:triangular_flag_on_post: Setup the **Prometheus** data monitoring stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml prometheus
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://prometheus.io/)
* [GitHub repository](https://github.com/prometheus/prometheus)
* [Docker Hub image](https://hub.docker.com/r/prom/prometheus)

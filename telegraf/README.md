# Telegraf - Data acquisition

:triangular_flag_on_post: Setup the **Telegraf** data acquisition stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml telegraf
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://www.influxdata.com/time-series-platform/telegraf/)
* [GitHub repository](https://github.com/influxdata/telegraf)
* [Docker Hub image](https://hub.docker.com/_/telegraf)

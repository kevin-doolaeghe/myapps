# InfluxDB - Data storage

:triangular_flag_on_post: Setup the **InfluxDB** data storage stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml influxdb
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://www.influxdata.com/)
* [GitHub repository](https://github.com/influxdata/influxdb)
* [Docker Hub image](https://hub.docker.com/_/influxdb)

# Data Manager

:triangular_flag_on_post: Setup the **Data Manager** stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml datamanager
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## Web access

Grafana's web interface is accessible via port `3000`.

:key: Default credentials :
* Username : `admin`
* Password : `changeme`

## References

* [Grafana website](https://grafana.com/)
* [Grafana image on Docker Hub](https://hub.docker.com/r/grafana/grafana)
* [InfluxDB website](https://www.influxdata.com/)
* [InfluxDB image on Docker Hub](https://hub.docker.com/_/influxdb)
* [Telegraf website](https://www.influxdata.com/time-series-platform/telegraf/)
* [Telegraf image on Docker Hub](https://hub.docker.com/_/telegraf)

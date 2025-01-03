# Home Assistant

:triangular_flag_on_post: Setup the **Home Assistant** stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml homeassistant
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## Web access

Home Assistant's web interface is accessible via port `8123`.

## References

* [Home Assistant website](https://www.home-assistant.io/)
* [Home Assistant repository on Github](https://github.com/home-assistant/core)
* [Home Assistant - Docker Installation](https://www.home-assistant.io/installation/linux#docker-compose)
* [Home Assistant - Tuya Integration](https://www.home-assistant.io/integrations/tuya/)
* [Home Assistant - InfluxDB Integration](https://www.home-assistant.io/integrations/influxdb)

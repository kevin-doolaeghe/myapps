# ESP Home - ESP board management

:triangular_flag_on_post: Setup the **ESP Home** ESP board management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml esp_home
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://esphome.io/)
* [GitHub repository](https://github.com/esphome/esphome)
* [Docker Hub image](https://hub.docker.com/r/esphome/esphome)

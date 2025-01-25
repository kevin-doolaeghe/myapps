# Mosquitto - Automation

:triangular_flag_on_post: Setup the **Mosquitto** automation stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml mosquitto
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://mosquitto.org/)
* [GitHub repository](https://github.com/eclipse-mosquitto/mosquitto)
* [Docker Hub image](https://hub.docker.com/_/eclipse-mosquitto)

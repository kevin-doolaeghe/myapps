# VaultWarden - Password management

:triangular_flag_on_post: Setup the **VaultWarden** password management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml vaultwarden
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Offical website](https://www.vaultwarden.net/)
* [GitHub repository](https://github.com/dani-garcia/vaultwarden)
* [Docker Hub image](https://hub.docker.com/r/vaultwarden/server)

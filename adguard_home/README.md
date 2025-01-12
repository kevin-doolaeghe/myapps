# AdGuard Home - DNS management

:triangular_flag_on_post: Setup the **AdGuard Home** DNS management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml adguard_home
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://adguard.com/)
* [GitHub repository](https://github.com/AdguardTeam/AdGuardHome)
* [Docker Hub image](https://hub.docker.com/r/adguard/adguardhome)

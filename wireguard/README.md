# WireGuard

:triangular_flag_on_post: Setup the **WireGuard** VPN stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml wireguard
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://www.wireguard.com/)
* [GitHub repository](https://github.com/wg-easy/wg-easy)

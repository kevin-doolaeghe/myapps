# Pi-Hole

:triangular_flag_on_post: Setup the **Pi-Hole** stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml pihole
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## Web access

Pi-Hole's web interface is accessible via port `80`.

:key: Default credentials :
* Email address : `admin`
* Password : `changeme`

## References

* [Pi-Hole website](https://pi-hole.net/)
* [Pi-Hole repository on Github](https://github.com/pi-hole/docker-pi-hole/)
* [Ubuntu - How to free up port 53, used by `systemd-resolved`](https://www.linuxuprising.com/2020/07/ubuntu-how-to-free-up-port-53-used-by.html)

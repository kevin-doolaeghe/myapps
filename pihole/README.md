# Pi-Hole

:triangular_flag_on_post: **Pi-Hole** application package.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml -p pihole
```

:warning: This program require a docker instance with **Swarm** mode enabled to be executed.

## Web access

Pi-Hole's web interface is accessible via port `80`.

:key: Default credentials :
* Email address : `admin`
* Password : `changeme`

## References

* [Pi-Hole](https://pi-hole.net/)
* [Docker Pi-Hole](https://github.com/pi-hole/docker-pi-hole/)
* [Ubuntu - How to free up port 53, used by `systemd-resolved`](https://www.linuxuprising.com/2020/07/ubuntu-how-to-free-up-port-53-used-by.html)

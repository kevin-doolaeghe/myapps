# WireGuard

:triangular_flag_on_post: **WireGuard** application package.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml -p wireguard
```

:warning: This program require a docker instance with **Swarm** mode enabled to be executed.

## Web access

WireGuard's web interface is accessible via port `51821`.

:key: Default credentials :
* Email address : :no_entry_sign:
* Password : `changeme`

:warning: Change the default password :

1. Generate the password using the following command :
```
docker run --rm -it ghcr.io/wg-easy/wg-easy wgpw 'changeme'
```

2. Update the `PASSWORD_HASH` environment variable in the `docker-compose.yml` file.

:memo: The Prometheus metrics are available on `http://0.0.0.0:51821/metrics`.

## References

* [WireGuard Easy for Docker](https://github.com/wg-easy/wg-easy)

# Nginx Proxy Manager

:triangular_flag_on_post: **Nginx Proxy Manager** application package.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml -p nginxproxymanager
```

:warning: This program require a docker instance with **Swarm** mode enabled to be executed.

## Web access

Nginx Proxy Manager's web interface is accessible via port `81`.

:key: Default credentials :
* Email address : `admin@example.com`
* Password : `changeme`

## Configuration

To connect the proxy to the other containers, it must be attached to the corresponding networks using the following command :
```
sudo docker network connect <network> nginxproxymanager
```

## References

* [Nginx Proxy Manager website](https://nginxproxymanager.com/)
* [Nginx Proxy Manager tutorial (Youtube)](https://www.youtube.com/watch?v=qlcVx-k-02E&t=434s)

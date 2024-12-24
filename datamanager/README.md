# Data Manager

:triangular_flag_on_post: **Data Manager** application package.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml -p datamanager
```

:warning: This program require a docker instance with **Swarm** mode enabled to be executed.

## Web access

Grafana's web interface is accessible via port `3000`.

:key: Default credentials :
* Username : `admin`
* Password : `changeme`

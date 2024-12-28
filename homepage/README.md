# Homepage dashboard

:triangular_flag_on_post: Setup **Homepage** dashboard stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml homepage
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## Web access

Homepage's web interface is accessible via port `3000`.

## References

* [Homepage website](https://gethomepage.dev/)
* [Homepage repository on Github](https://github.com/gethomepage/homepage)

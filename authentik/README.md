# Authentik

:triangular_flag_on_post: Setup the **Authentik** stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml authentik
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## References

* [Authentik website](https://goauthentik.io/)
* [Authentik repository on Github](https://github.com/goauthentik/authentik)

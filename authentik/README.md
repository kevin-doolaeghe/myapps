# Authentik - Authentication management

:triangular_flag_on_post: Setup the **Authentik** authentication management stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml authentik
```

:warning: This program require a Docker instance **with Swarm mode** enabled to be executed.

## References

* [Official website](https://goauthentik.io/)
* [GitHub repository](https://github.com/goauthentik/authentik)

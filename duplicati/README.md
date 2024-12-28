# Duplicati backup manager

:triangular_flag_on_post: Setup the **Duplicati** backup manager stack.

## Author

**Kevin Doolaeghe**

## Setup

```
sudo docker stack deploy -c docker-compose.yml duplicati
```

:warning: This program require a Docker instance **with Swarm** mode enabled to be executed.

## Setup external storage for backups

1. Plug your USB drive to the Raspberry Pi.

2. Find the name of your USB drive (e.g. `/dev/sda1`) using the following command :
```
lsblk
```

3. Edit the `/etc/fstab` file :
```
sudo nano /etc/fstab
```

4. Add the USB drive entry and save the file to auto-mount the USB drive at startup :
```
/dev/sda1  /mnt/data  auto  defaults  0  0
```

5. Create and initialize the mount directory :
```
sudo mkdir /mnt/data
sudo chmod 777 /mnt/data
```

6. Check if the `fstab` entry is working :
```
sudo mount -a
ls /mnt/data
```
:memo: The drive will now be automatically mounted to `/mnt/data` after startup.

## Web access

Duplicati's web interface is accessible via port `8200`.

## References

* [Duplicati website](https://duplicati.com/)
* [Duplicati image on Docker Hub](https://hub.docker.com/r/duplicati/duplicati)

# PI-HOLE & Unbound Docker Compose

## PreRequistes Installation

### Docker & Docker Compose

This project depends on having Docker and Docker Compose installed on the machine 
you plan to run Pihole on. Ensure your machine has at least 4GB of RAM.

To check if `docker` and `docker-compose` is already installed run the following commands from the command line:

```
$ docker --version
Docker version 24.0.6, build ed223bc
$ docker-compose --version
docker-compose version 1.28.0, build d02a7b1a
```

If nothing was returned when running the above commands follow docker's recommend 
installation method found here under [Scenario one: Install Docker Desktop](https://docs.docker.com/compose/install/#scenario-one-install-docker-desktop) for your operating system and/or linux distribution. If your machine is a Raspberry Pi or a single board of some kind check out these operating systems for getting docker up and running

- [Casa OS](https://github.com/IceWhaleTech/CasaOS)
- [Hypriot OS](https://blog.hypriot.com/downloads/)

### Git (optional)

If you are planning to clone to this repository you will need git. Check that you have 
it installed with `git --version`. A version number should be returned on the command 
line. If not installed on your machine here are instructions below

- [Installation Instructions for Operating Systems](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Running PiHole & Unbound

0a. Clone this repository

    ```
    # linux/mac commands

    # Using https. Use SSH if contributing to the project 
    $ git clone https://github.com/Audiosutras/pihole-unbound-dockercompose.git

    # make pihole-unbound-dockercompose our working directory
    $ cd pihole-unbound-dockercompose
    ```

0b. Download repository as a zip file

    ```
    # linux/mac commands

    # download zip file of master branch
    $ wget -O pihole-unbound-dockercompose-master.zip https://github.com/Audiosutras/pihole-unbound-dockercompose/archive/refs/heads/master.zip

    # unzip the zip file
    $ unzip pihole-unbound-dockercompose-master.zip

    # make pihole-unbound-dockercompose our working directory
    $ cd pihole-unbound-dockercompose-master
    ```

1. Create an `.env` file in the same directory as the `docker-compose.yml` file

    ```
    # linux/mac commands

    $ ls
    docker-compose.yml  READMe.md

    # opens nano editor
    $ touch .env && sudo nano .env
    ```

    Paste and replace `<super secret password for logging into pihole dashboard>` with your 
    password.

    ```
    PIHOLE_PWD=<super secret password for logging into pihole dashboard>
    ```

Press `CTRL + X` then `Y` and then `ENTER` to exit the editor.

2. Run the project detached as a background process. If you are running this project on 
Ubuntu there are additional steps that need to be completed. Please see the section below before proceeding.

    ```
    $ docker-compose up -d
    ```

Pihole and Unbound will restart automatically unless explicitly stopped by the user.


3. Get the IP Address of Pihole instance

    - If wanting to use Pihole on the machine you just installed it on without local 
    network coverage, the IP address you will use for your DNS server is `127.0.0.1` (localhost).
    - For local network coverage, you will need to know the local IP address for the machine you placed Pihole on. Get that on linux by running
    ```
        # make sure to write down the first entry in this list
        $ hostname -I
    ```

4. Confirm PiHole is using Unbound as the upstream DNS

    - Navigate to `http://<ip-address>/admin` replacing `<ip-address` with the address 
    you obtained in step 3.
    - Input the `PIHOLE_PWD` password you chose in step 1 to access the admin
    - Navigate to `Settings`, click on the `DNS` tab. Under `Custom 1 (IPv4)` you 
    should checked `10.1.1.3#53`. This `Unbound`. 
    - You can uncheck this and use any of the other upstream dns servers like `Cloudflare` and `Quad9` when you want to.

5. Start using Pihole - [Article: Configure Clients to use Pihole](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245)

    - On the Pihole installed machine you can navigate to Wifi or Network Settings and update the `DNS` section for your internet connection by inputing `127.0.0.1` as the 
    value.
    - For local network coverage of all devices you will need to update Static DNS settings found in your router admin page. You will set 
    the DNS value to the local IP address you retrieved in step 3.

For more Information see the article linked in the step 5 title.

## Useful Resources

- [Setup Pihole Docker (Official)](https://github.com/pi-hole/docker-pi-hole/#running-pi-hole-docker)
- [Blog Post](https://pimylifeup.com/pi-hole-docker/)
- [resolvconf ubuntu 17+ issue fix](https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu)
- [Second Helpful Blog Post - Run PiHole on Localhost](https://thanosmour-tk.medium.com/run-pi-hole-in-localhost-and-some-extras-4b50e76611e6)
- [Unbound as Upstream DNS](https://nlnetlabs.nl/projects/unbound/about/)
- [Reddit Thread for Getting Unbound to run in same Container as PiHole](https://www.reddit.com/r/docker/comments/rbgrm8/how_to_install_unbound_and_pihole_in_docker_using/)

Use in combination with the browser extension [uBlock Origin](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm) for blocking youtube ads for example. Update: Youtube is getting hip to ad blockers of all kinds. Check out these open source solutions as work around.
    - [invidious.io](https://invidious.io/)

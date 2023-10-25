# PI-HOLE & Unbound Docker Compose

## Prerequistes Installations

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
Ubuntu (and maybe Fedora) there are [additional steps](#ubuntu-additional-steps) that need to be completed before continuing with step 2.

    ```
    $ docker-compose up -d
    ```

Pihole and Unbound will restart automatically unless explicitly stopped by the user.


3. Get the IP Address of the Pihole instance

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
    - Navigate to `Settings`, click on the `DNS` tab. Under `Upstream DNS` `Custom 1 (IPv4)` you should see checked `10.1.1.3#53`. This is `Unbound`'s internal IP address. 
    - You can uncheck this and use any of the other upstream dns servers like `Cloudflare` and `Quad9` when you want to.

5. Start using Pihole - [Article: Configure Clients to use Pihole](https://discourse.pi-hole.net/t/how-do-i-configure-my-devices-to-use-pi-hole-as-their-dns-server/245)

    - On the Pihole installed machine you can navigate to Wifi or Network Settings and update the `DNS` section for your internet connection by inputing `127.0.0.1` as the 
    value.
    - For local network coverage of all devices you will need to update Static DNS settings found in your router admin page. You will set 
    the DNS value to the local IP address you retrieved in step 3.

For more Information see the article linked above for step 5.

### Ubuntu Additional Steps

In order to proceed to step 2 in [Running PiHole & Unbound](#running-pihole--unbound) you will need to update `systemd-resolved` or disable it.

1a. [Offical Pihole Solution for Ubuntu & Fedora - Update It](https://github.com/pi-hole/docker-pi-hole/#installing-on-ubuntu-or-fedora)

1b. [The Unoffical Solution for the Streets - Disable It](https://askubuntu.com/questions/907246/how-to-disable-systemd-resolved-in-ubuntu). From the command line:

    ```
    # The Unoffical Solution for the Streets

    $ sudo systemctl disable systemd-resolved
    $ sudo systemctl stop systemd-resolved
    $ sudo nano /etc/NetworkManager/NetworkManager.conf 
    ```
Add `dns=default` under `[main]` section in `/etc/NetworkManager/NetworkManager.conf`


    ```
    # inside '/etc/NetworkManager/NetworkManager.conf'
 
    [main]
    ...
    dns=default
    ```
Press `CTRL + X` then `Y` and then `ENTER` to exit the editor.

Delete the sysmlink `/etc/resolv.conf`

    ```
    $ rm /etc/resolv.conf
    ```

Restart NetworkManager

    ```
    $ sudo systemctl restart NetworkManager
    ```

Now we can proceed back to step 2.

## More Useful Resources & Articles

### Resources

- [Setup Pihole Docker (Official)](https://github.com/pi-hole/docker-pi-hole/#running-pi-hole-docker)
- [Unbound as Upstream DNS](https://nlnetlabs.nl/projects/unbound/about/)

### Articles 

- [PiHole Docker - Pi My Life UP](https://pimylifeup.com/pi-hole-docker/)
- [Run PI Hole In Localhost And Some Extras - Medium](https://thanosmour-tk.medium.com/run-pi-hole-in-localhost-and-some-extras-4b50e76611e6)
- [How To Install Unbound and Pi-hole in Docker using Docker Compose](https://www.reddit.com/r/docker/comments/rbgrm8/how_to_install_unbound_and_pihole_in_docker_using/)

## Up The Adblocking Power

The power of Pihole as a DNS Sinkhole is by blocking domains that are associated with ads and malware before the connection can be made to the client. It needs to be stated that Pihole does not actually crawl pages to block ads. You will notice on sites like Youtube that video ads are still being shown. To block these ads you will need to use an adblocker. We recommend [uBlock Origin](https://github.com/gorhill/uBlock) as an effective open source tool that can be run as add-on in the browser.  

### Uh Oh! Another Youtube Crack Down

Youtube is going to block the video player on their website from running if they detect that you are using adblock add-on. Fortunately there are open source alternatives for you to watch your favorite content creators. Check out

- [invidious homepage](https://invidious.io/) 
- [invidious instances*](https://docs.invidious.io/instances/)    

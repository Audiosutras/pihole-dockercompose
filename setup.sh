#!/bin/bash

zshrc_or_bashrc_brew_config () {
    echo ""
    echo "Homebrew configuration should go to which shell config file?"
    read -p "Answer [zshrc/bashrc]: " shell

    case "$shell" in
        "zshrc")
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc
            source ~/.zshrc
            ;;
        "bashrc")
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
            source ~/.bashrc
            ;;
        *)
            echo ""
            echo "Invalid Response - Exiting Setup Script for Pihole & Unbound"
            exit 1
            ;;
    esac
}

curl_install_homebrew () {
    echo ""
    echo "The chosen installation method for Docker requires Homebrew."
    echo "Does Homebrew need to be installed?"
    read -p "Answer [y/n]: " brew_answer

    case "$brew_answer" in
        "y")
            echo ""
            echo "Installing Homebrew.."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            zshrc_or_bashrc_brew_config
            ;;
        "n")
            echo ""
            echo "Moving on..."
            ;;
        *)
            echo ""
            echo "Invalid Response - Exiting Setup Script for Pihole & Unbound"
            exit 1
            ;;
    esac
}

brew_install_docker () {
    echo ""
    echo "Pi-hole & Unbound run in docker containers."
    echo "Does Docker need to be installed?"
    read -p "Answer [y/n]: " docker_answer

    case "$docker_answer" in
        "y")
            curl_install_homebrew
            echo ""
            echo "Installing Docker.."
            brew install --cask docker
            ;;
        "n")
            echo ""
            echo "Moving on..."
            ;;
        *)
            echo ""
            echo "Invalid Response - Exiting Setup Script for Pihole & Unbound"
            exit 1
            ;;
    esac
}

pihole_config () {
    echo ""
    echo "Timezone for Pi-hole? (default: America/New_York)"
    read -p "Timezone: " timezone
    echo ""
    echo "Set a password for Pi-hole's admin interface? (default: pihole)"
    read -p "Password: " -s password

    if [[ -e './.env' ]]; then
        rm ./.env
        touch ./.env
    fi

    echo "PIHOLE_PWD=${password:=pihole}" >> .env
    echo "PIHOLE_TZ=${timezone:=America/New_York}" >> .env
}

nano_network_manager () {
    echo ""
    echo "The nano text editor will open for /etc/NetworkManager/NetworkManager.conf."
    echo "Under [main] you will need to add 'dns=default'"
    echo "Inside of the file for example: "
    echo ""
    echo "   | [main]"
    echo "   | ..."
    echo "   | ..."
    echo "   | dns=default"
    echo "   | ..."
    echo ""
    echo "Press 'CTRL + X' then 'Y' and then 'ENTER' to exit the editor"
    echo ""
    echo ""
    echo "Are you ready to proceed?"
    read -p "Answer [y/n]:" nano_answer

    case "$nano_answer" in
        "y")
            sudo nano /etc/NetworkManager/NetworkManager.conf
            ;;
        "n")
            echo ""
            echo "Re-enabling systemd-resolved"
            sudo systemctl reenable systemd-resolved
            sudo systemctl start systemd-resolved
            ;;
        *)
            echo ""
            echo "Re-enabling systemd-resolved"
            sudo systemctl reenable systemd-resolved
            sudo systemctl start systemd-resolved
            echo ""
            echo "Invalid Response - Exiting Setup Script for Pihole & Unbound"
            exit 1
            ;;
    esac
}

debian_additional_steps () {
    echo ""
    echo "Have you already disabled systemd-resolved?"
    read -p "Answer [y/n]: " disabled

    case "$disabled" in
        "y")
            echo ""
            echo "Moving on..."
            ;;
        "n")
            echo ""
            echo "Disabling..."
            sudo systemctl disable systemd-resolved
            sudo systemctl stop systemd-resolved
            nano_network_manager
            rm /etc/resolv.conf
            sudo systemctl restart NetworkManager 
            ;;
        *)
            echo ""
            echo "Invalid Response - Exiting Setup Script for Pihole & Unbound"
            exit 1
            ;;
    esac
}

run () {
    echo ""
    echo "Starting up Containers..."
    docker-compose up -d
}

pihole_admin_info () {
    read local_ip rest <<< $(hostname -I)
    echo ""
    echo "MACHINE PI-HOLE HAS BEEN INSTALLED ON COVERAGE"
    echo "-----------------------------------------------"
    echo "Set the DNS server for your Internet Connection to use the following IP address."
    echo "Localhost IP Address: $local_ip"
    echo "On your machine you can navigate to the below address to access the Pi-hole admin."
    echo "http://127.0.0.1/admin"
    echo ""
    echo "LOCAL NETWORK PI-HOLE COVERAGE"
    echo "------------------------------"
    echo "Set the DNS server on your router to use the following IP address."
    echo "Internal IP Address: $local_ip"
    echo "On your local network you can navigate to the below address to access the Pi-hole admin."
    echo "http://$local_ip/admin"
    echo ""
}

operating_system () {
    PS3="SELECT operating system: "

    echo ""
    echo "Please Select Your Operating System"
    select os in Ubuntu/Debian
    do
        case $os in
            "Ubuntu/Debian")
                brew_install_docker
                pihole_config
                debian_additional_steps
                run
                pihole_admin_info
                break
                ;;
            *)
                echo "Invalid option - $REPLY"
                ;;
        esac
    done
}

operating_system


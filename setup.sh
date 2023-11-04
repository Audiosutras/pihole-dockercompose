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

debian_additional_steps () {
    
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
                break
                ;;
            *)
                echo "Invalid option - $REPLY"
                ;;
        esac
    done
}

operating_system


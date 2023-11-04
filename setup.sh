#!/bin/bash

debian_install_docker () {
    echo ""
    echo "Pi-hole & Unbound run in docker containers."
    echo "Does Docker need to be installed?"
    read -p "Answer [y/n]: " docker_answer

    case "$docker_answer" in
        "y")
            echo ""
            echo "The chosen installation method for Docker requires Homebrew."
            echo "Does Homebrew need to be installed?"
            read -p "Answer [y/n]: " $brew_answer
            ;;
        "n")
            echo ""
            echo "Moving on..."
            ;;
        *)
            echo ""
            echo "Invalid Response - Exiting Setup Script for Pihole & Unbound"
            exit 1
    esac
}

operating_system () {
    PS3="SELECT operating system: "

    echo ""
    echo "Please Select Your Operating System"
    select os in Ubuntu/Debian
    do
        case $os in
            "Ubuntu/Debian")
                debian_install_docker
                break
                ;;
            *)
                echo "Invalid option - $REPLY"
                ;;
        esac
    done
}

operating_system


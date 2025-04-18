#!/usr/bin/env bash
################################################################################
#
# bootstrap
# ----------------
# Bootstrap a container for Homelab Pull
#
# @author Nicholas Wilde, 0x08b7d7a3
# @date 14 Apr 2025
# @version 0.1.0
#
################################################################################

set -e
set -o pipefail

REQUIREMENTS_URL="https://github.com/nicholaswilde/homelab-pull/raw/refs/heads/main/requirements.yaml"
PASSWORD_PATH="${HOME}/.config/homelab-pull/password"
PASSWORD_FOLDER=$(dirname "${PASSWORD_PATH}")


readonly REQUIREMENTS_URL
readonly PASSWORD_PATH
readonly PASSWORD_FOLDER

bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
blue=$(tput setaf 4)
default=$(tput setaf 9)
white=$(tput setaf 7)

readonly bold
readonly normal
readonly red
readonly blue
readonly default
readonly white

function print_text(){
  echo "${blue}==> ${white}${bold}${1}${normal}"
}

function raise_error(){
  printf "${red}%s\n" "${1}"
  exit 1
}

# Check if variable is set
# Returns false if empty
function is_set(){
  [ -n "${1}" ]
}

function command_exists() {
  command -v "$1" >/dev/null 2>&1
}

function start_meassage(){
  print_text "Starting homelab-pull bootstrap script."
}

function check_password(){
  if [[ ! -e "${PASSWORD_PATH}" ]]; then
    # Prompt for the first password input
    read -sp "Enter vault password (${PASSWORD_PATH}): " password_1
    echo # Add a newline after hidden input
    
    # Prompt for the confirmation password input
    read -sp "Confirm vault password: " password_2
    echo # Add a newline after hidden input
    
    # Compare the two inputs
    if [[ "$password_1" != "$password_2" ]]; then
      rais_error "Passwords do not match."
    fi

    [ ! -d "${PASSWORD_FOLDER}" ] && mkdir -p "${PASSWORD_FOLDER}"
    printf %s "$password_1" > "${PASSWORD_PATH}"
    if [[ ! -e "${PASSWORD_PATH}" ]]; then
      raise_error "Could not create password file"
    fi
  else
    print_text "Password file already exists"
  fi
}

function install_sudo(){
  if ! command_exists sudo; then
    print_text "Installing sudo"
    apt install sudo -y
  else
    print_text "sudo is already installed"
  fi
}

function install_deps(){
  print_text "Installing dependencies"
  sudo apt install -y \
    wget \
    git
}

function install_pipx(){
  if ! command_exists pipx; then
    print_text "Installing pipx"
    sudo apt install pipx -y
    export PATH=$PATH:$HOME/.local/bin
  else
    print_text "pipx is already installed"
  fi
}

function install_ansible_core(){
  if ! command_exists ansible; then
    print_text "Installing ansible-core"
    pipx install ansible-core
  else
    print_text "ansible-core is already installed"
  fi
}

function install_collections(){
  print_text "Installing collections"
  $HOME/.local/bin/ansible-galaxy collection install -r <(curl -fsSL "${REQUIREMENTS_URL}")
}

function show_message(){
  print_text "Add to your bash profile: 'export PATH=\$PATH:\$HOME/.local/bin'"
}

function main(){
  start_meassage
  check_password
  install_sudo
  sudo apt update
  install_deps
  install_pipx
  install_ansible_core
  install_collections
  show_message
}

main "$@"

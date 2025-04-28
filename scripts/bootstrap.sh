#!/usr/bin/env bash
################################################################################
#
# bootstrap
# ----------------
# Bootstrap a container for Homelab Pull
#
# @author Nicholas Wilde, 0xb299a622
# @date 14 Apr 2025
# @version 0.1.0
#
################################################################################

set -e
set -o pipefail

: ${REQUIREMENTS_URL:="https://github.com/nicholaswilde/homelab-pull/raw/refs/heads/main/requirements.yaml"}
: ${PASSWORD_PATH:="${HOME}/.config/homelab-pull/password"}
: ${PASSWORD_FOLDER:=$(dirname "${PASSWORD_PATH}")}

: ${LPASS_LOGIN:="ncwilde43@gmail.com"}

: ${LPASS_SSH_NAME:="ssh"}
: ${LPASS_SSH_ATTACH_ID:="att-4322045537695550419-12027"}

: ${LPASS_GPG_NAME:="gpg"}
: ${LPASS_GPG_ATTACH_ID:="att-8017296795546256342-44224"}

: ${LPASS_SOPS_AGE_NAME:="sops-age"}
: ${LPASS_SOPS_AGE_ATTACH_ID:="att-2571789250549588435-38084"}

: ${LPASS_ANSIBLE_VAULT_NAME:="homelan-pull"}

readonly REQUIREMENTS_URL
readonly PASSWORD_PATH
readonly PASSWORD_FOLDER
readonly LPASS_LOGIN
readonly LPASS_SSH_NAME
readonly LPASS_SSH_ATTACH_ID
readonly LPASS_GPG_NAME
readonly LPASS_GPG_ATTACH_ID
readonly LPASS_SOPS_AGE_NAME
readonly LPASS_SOPS_AGE_ATTACH_ID
readonly LPASS_ANSIBLE_VAULT_NAME

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

function logged_in(){
  lpass status -q
}

function install_lpass(){
  if ! command_exists lpass; then
    print_text "Installing lastpass-cli"
    sudo apt install lastpass-cli -y
  else
    print_text "lastpass-cli is already installed"
  fi
  [[ ! -d ~/.local/share/lpass ]] && mkdir -p ~/.local/share/lpass
  export LPASS_DISABLE_PINENTRY=1
  if ! logged_in; then
    print_text "Not logged in"
    lpass login "${LPASS_LOGIN}"
  else
    print_text "Logged in"
  fi
}

function setup_ansible_vault(){
  if [[ -e "${PASSWORD_PATH}" ]]; then
    print_text "ansible-vault password already exists"
  else
    print_text "Setting up ansible-vault password"
    [ ! -d "${PASSWORD_FOLDER}" ] && mkdir -p "${PASSWORD_FOLDER}"
    lpass show "${LPASS_ANSIBLE_VAULT_NAME}" --password -q > "${PASSWORD_PATH}"
    chmod 0600 "${PASSWORD_PATH}"
  fi
}

function setup_gpg_key(){
  if ! command_exists gpg; then
    print_text "Setting up GPG key"
    sudo apt install gpg -y
  else
    print_text "gpg is already installed"
  fi
  # pass-git-helper
  GPG_TTY=$(tty)
  export GPG_TTY
  lpass show "${LPASS_GPG_NAME}" --attach="${LPASS_GPG_ATTACH_ID}" -q | gpg --import
}

function setup_ssh_key() {
  if [[ -f "~/.ssh/id_ed25519" ]]; then
    print_text "SSH key already exists"
  else
    print_text "Setting up SSH key"
    [[ ! -d ~/.ssh ]] && mkdir -p ~/.ssh
    lpass show "${LPASS_SSH_NAME}" --attach="${LPASS_SSH_ATTACH_ID}" -q > ~/.ssh/id_ed25519
    chmod 0600 ~/.ssh/id_ed25519
  fi
}

function setup_sops_age_key(){
  if [[ -f "~/.config/sops/age/keys.txt" ]]; then
    print_text "SOPS age key already exists"
  else
    print_text "Setting up SOPS age key"
    [[ ! -d ~/.config/sops/age ]] && mkdir -p ~/.config/sops/age
    lpass show "${LPASS_SOPS_AGE_NAME}" --attach="${LPASS_SOPS_AGE_ATTACH_ID}" -q > ~/.config/sops/age/keys.txt
    chmod 0600 ~/.config/sops/age/keys.txt
  fi
}

function show_message(){
  print_text "Add to your bash profile: 'export PATH=\$PATH:\$HOME/.local/bin'"
}

function main(){
  start_meassage
  install_sudo
  sudo apt update
  install_deps
  install_pipx
  install_lpass
  setup_ansible_vault
  setup_gpg_key
  setup_ssh_key
  setup_sops_age_key
  # check_password
  install_ansible_core
  install_collections
  show_message
}

main "$@"

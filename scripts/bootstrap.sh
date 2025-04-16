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

# set -e
# set -o pipefail

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

# Check if EUID is 0 (root)
function check_root(){
  if [[ $EUID -ne 0 ]]; then
     raise_error "Error: This script must be run as root."
  fi
}

function install_pipx(){
  print_text "Installing pipx"
  if command_exists pipx; then
    
  else
    apt install pipx
  fi
}

function install_ansible_core(){
  sudo pipx install ansible-core
}

function main(){
  check_root
  install_pipx
  install_ansible_core
}

main "$@"

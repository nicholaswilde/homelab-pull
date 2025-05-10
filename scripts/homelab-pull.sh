#!/usr/bin/env bash
################################################################################
#
# homelab-pull
# ----------------
# Use ansible-pull to run playbooks on the localhost
#
# @author Nicholas Wilde, 0xb299a622
# @date 10 May 2025
# @version 0.1.0
#
################################################################################

set -e
set -o pipefail

: ${HOMELAB_PULL_REPO:="https://github.com/nicholaswilde/homelab-pull.git"}

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

function check_ansible_pull() {
  if ! command_exists "ansible-pull"; then
    raise_error "ansible-pull is not installed"
  fi
}

function run_homelab_pull(){
  ansible-pull -U "${HOMELAB_PULL_REPO}" -i "$(uname -n),"
}

function main(){
  check_ansible_pull
  run_homelab_pull
}

main "@"

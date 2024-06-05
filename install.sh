#!/usr/bin/env bash

set -euo pipefail
shopt -s inherit_errexit nullglob

RD="\033[01;31m"
YW="\033[33m"
GN="\033[1;92m"
CL="\033[m"
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"

msg_info() {
  local msg="$1"
  printf " %s %s%s..." "${HOLD}" "${YW}" "${msg}"
}

msg_ok() {
  local msg="$1"
  printf "%b %s %s%s%s\n" "${BFR}" "${CM}" "${GN}" "${msg}" "${CL}"
}

msg_error() {
  local msg="$1"
  printf "%b %s %s%s%s\n" "${BFR}" "${CROSS}" "${RD}" "${msg}" "${CL}"
}

header_info() {
  clear
  cat <<"EOF"
##CORELAB API CHALLENGE PHP##
EOF
}

clone_repo() {
    msg_info "Cloning repository"
    if git clone https://github.com/silviosantosneto/corelab-api-challenge-php-test; then
        cd corelab-api-challenge-php-test || return 1
        msg_ok "Repository cloned"
    else
        msg_error "Failed to clone repository"
        return 1
    fi
}

setup_environment() {
    cp .env.example .env || { msg_error "Failed to copy .env file"; return 1; }
    msg_info "Installing dependencies"
    if docker run --rm -u "$(id -u):$(id -g)" -v "$(pwd):/var/www/html" -w /var/www/html laravelsail/php83-composer:latest composer install -q --ignore-platform-reqs; then
        msg_ok "Dependencies installed"
    else
        msg_error "Failed to install dependencies"
        return 1
    fi
}

install_sail() {
    msg_info "Installing Laravel Sail"
    if docker run --rm -u "$(id -u):$(id -g)" -v "$(pwd):/var/www/html" -w /var/www/html laravelsail/php83-composer:latest php artisan sail:install; then
        msg_ok "Laravel Sail installed"
    else
        msg_error "Failed to install Laravel Sail"
        return 1
    fi
}

generate_key() {
    msg_info "Generating application key"
    if docker run --rm -u "$(id -u):$(id -g)" -v "$(pwd):/var/www/html" -w /var/www/html laravelsail/php83-composer:latest php artisan key:generate; then
        msg_ok "Application key generated"
    else
        msg_error "Failed to generate application key"
        return 1
    fi
}

start_sail() {
    msg_info "Starting Laravel Sail"
    if ./vendor/bin/sail up -d; then
        msg_ok "Laravel Sail started"
    else
        msg_error "Failed to start Laravel Sail"
        return 1
    fi
}

# Execução dos comandos fornecidos
main() {
  header_info
  clone_repo
  setup_environment
  install_sail
  generate_key
  start_sail
}

main "$@"

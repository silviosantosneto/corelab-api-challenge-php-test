#!/usr/bin/env bash

# Definição de Funções
header_info() {
  clear
  cat <<"EOF"
CORELAB API
EOF
}

# Definição de Variáveis de Cor
RD=$(echo "\033[01;31m")
YW=$(echo "\033[33m")
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"

# Configuração Inicial do Script
set -euo pipefail
shopt -s inherit_errexit nullglob

# Funções para Mensagens de Saída
msg_info() {
  local msg
  msg="$1"
  printf " ${HOLD} ${YW}%s..." "$msg"
}

msg_ok() {
  local msg
  msg="$1"
  printf "%b ${CM} ${GN}%s${CL}\n" "${BFR}" "$msg"
}

msg_error() {
  local msg
  msg="$1"
  printf "%b ${CROSS} ${RD}%s${CL}\n" "${BFR}" "$msg" >&2
}

# Função para executar comandos com validação e mensagens de erro
run_command() {
  local cmd msg
  cmd="$1"
  msg="$2"
  msg_info "$msg"
  if ! eval "$cmd"; then
    msg_error "$msg failed"
    return 1
  fi
  msg_ok "$msg completed"
}

# Função principal
main() {
  header_info
  run_command "git clone https://github.com/silviosantosneto/corelab-api-challenge-php-test && cd corelab-api-challenge-php-test && cp .env.example .env" "Cloning repository"
  run_command "docker run --rm -u $(id -u):$(id -g) -v $(pwd):/var/www/html -w /var/www/html laravelsail/php83-composer:latest composer install -q --ignore-platform-reqs" "Installing dependencies"
  run_command "docker run --rm -u $(id -u):$(id -g) -v $(pwd):/var/www/html -w /var/www/html laravelsail/php83-composer:latest php artisan sail:install" "Installing Laravel Sail"
  run_command "docker run --rm -u $(id -u):$(id -g) -v $(pwd):/var/www/html -w /var/www/html laravelsail/php83-composer:latest php artisan key:generate" "Generating application key"
  run_command "./vendor/bin/sail up -d" "Starting Laravel Sail"
}

main "$@"

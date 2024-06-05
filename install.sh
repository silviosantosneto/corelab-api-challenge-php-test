#!/usr/bin/env bash

# Configuração Inicial do Script
set -euo pipefail
shopt -s inherit_errexit nullglob

# Carregar Funções e Variáveis
source ./include/colors.sh
source ./include/messages.sh
source ./include/functions.sh

# Execução dos comandos fornecidos
main() {
  header_info
  clone_repo
  setup_environment
  install_sail
  generate_key
  start_sail

  msg_ok "Application setup completed"
}

main "$@"

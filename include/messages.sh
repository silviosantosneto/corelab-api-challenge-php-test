#!/usr/bin/env bash

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

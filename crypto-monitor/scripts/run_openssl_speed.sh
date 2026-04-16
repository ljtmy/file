#!/usr/bin/env bash
set -euo pipefail

THREADS="${1:-1}"
ALGO="${2:-aes-256-cbc}"
DURATION="${3:-30}"

if ! [[ "${THREADS}" =~ ^[0-9]+$ ]] || [ "${THREADS}" -le 0 ] || [ "${THREADS}" -gt 1024 ]; then
  echo "Error: THREADS must be a positive integer <= 1024, got '${THREADS}'" >&2
  exit 1
fi

if ! [[ "${DURATION}" =~ ^[0-9]+$ ]] || [ "${DURATION}" -le 0 ]; then
  echo "Error: DURATION must be a positive integer, got '${DURATION}'" >&2
  exit 1
fi

if ! [[ "${ALGO}" =~ ^[a-zA-Z0-9._-]+$ ]]; then
  echo "Error: ALGO contains invalid characters: '${ALGO}'" >&2
  exit 1
fi

echo "Running openssl speed with threads=${THREADS}, algo=${ALGO}, seconds=${DURATION}"
openssl speed -multi "${THREADS}" -seconds "${DURATION}" "${ALGO}"


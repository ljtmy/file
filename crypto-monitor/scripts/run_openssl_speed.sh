#!/usr/bin/env bash
set -euo pipefail

THREADS="${1:-1}"
ALGO="${2:-aes-256-cbc}"
DURATION="${3:-30}"

if ! [[ "${THREADS}" =~ ^[1-9][0-9]*$ ]]; then
  echo "THREADS must be a positive integer" >&2
  exit 1
fi

if ! [[ "${DURATION}" =~ ^[1-9][0-9]*$ ]]; then
  echo "DURATION must be a positive integer" >&2
  exit 1
fi

if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl not found in PATH" >&2
  exit 1
fi

echo "Running openssl speed with threads=${THREADS}, algo=${ALGO}, seconds=${DURATION}"
openssl speed -multi "${THREADS}" -seconds "${DURATION}" "${ALGO}"

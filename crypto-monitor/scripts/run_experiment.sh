#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <libcrypto-path> <symbol>"
  exit 1
fi

LIBCRYPTO_PATH="$1"
SYMBOL="$2"
THREADS_LIST=(1 4 8 16 64 128)
ALGO="${ALGO:-aes-256-cbc}"
DURATION="${DURATION:-30}"
OUT_DIR="${OUT_DIR:-results}"

if [ ! -f "${LIBCRYPTO_PATH}" ]; then
  echo "Error: library not found: '${LIBCRYPTO_PATH}'" >&2
  exit 1
fi

if ! [[ "${SYMBOL}" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
  echo "Error: SYMBOL contains invalid characters: '${SYMBOL}'" >&2
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

mkdir -p "${OUT_DIR}"

for threads in "${THREADS_LIST[@]}"; do
  echo "==> threads=${threads}"
  openssl speed -multi "${threads}" -seconds "${DURATION}" "${ALGO}" \
    > "${OUT_DIR}/openssl-speed-${threads}.log" 2>&1 &
  SPEED_PID=$!

  sleep 1

  sudo ./build/crypto-monitor \
    --pid "${SPEED_PID}" \
    --binary "${LIBCRYPTO_PATH}" \
    --symbol "${SYMBOL}" \
    --duration "${DURATION}" \
    --output "${OUT_DIR}/monitor-${threads}.json" \
    --format json \
    > "${OUT_DIR}/monitor-${threads}.log" 2>&1

  wait "${SPEED_PID}" || true
done

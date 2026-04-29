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
MONITOR_BIN="${MONITOR_BIN:-./build/crypto-monitor}"
INTERVAL="${INTERVAL:-2}"
STARTUP_DELAY="${STARTUP_DELAY:-0}"

speed_pid=""

cleanup() {
  if [[ -n "${speed_pid}" ]] && kill -0 "${speed_pid}" 2>/dev/null; then
    kill "${speed_pid}" 2>/dev/null || true
    wait "${speed_pid}" 2>/dev/null || true
  fi
}

trap cleanup EXIT

if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl not found in PATH" >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo not found in PATH" >&2
  exit 1
fi

if [[ ! -x "${MONITOR_BIN}" ]]; then
  echo "monitor binary not found or not executable: ${MONITOR_BIN}" >&2
  exit 1
fi

if [[ ! -f "${LIBCRYPTO_PATH}" ]]; then
  echo "libcrypto path not found: ${LIBCRYPTO_PATH}" >&2
  exit 1
fi

if ! [[ "${DURATION}" =~ ^[1-9][0-9]*$ ]]; then
  echo "DURATION must be a positive integer" >&2
  exit 1
fi

if ! [[ "${INTERVAL}" =~ ^[1-9][0-9]*$ ]]; then
  echo "INTERVAL must be a positive integer" >&2
  exit 1
fi

if ! [[ "${STARTUP_DELAY}" =~ ^[0-9]+$ ]]; then
  echo "STARTUP_DELAY must be a non-negative integer" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

for threads in "${THREADS_LIST[@]}"; do
  echo "==> threads=${threads}"
  openssl speed -multi "${threads}" -seconds "${DURATION}" "${ALGO}" \
    > "${OUT_DIR}/openssl-speed-${threads}.log" 2>&1 &
  speed_pid=$!

  if [[ "${STARTUP_DELAY}" -gt 0 ]]; then
    sleep "${STARTUP_DELAY}"
  fi

  sudo "${MONITOR_BIN}" \
    --pid "${speed_pid}" \
    --binary "${LIBCRYPTO_PATH}" \
    --symbol "${SYMBOL}" \
    --interval "${INTERVAL}" \
    --duration "${DURATION}" \
    --output "${OUT_DIR}/monitor-${threads}.json" \
    --format json \
    > "${OUT_DIR}/monitor-${threads}.log" 2>&1

  wait "${speed_pid}" || true
  speed_pid=""
done

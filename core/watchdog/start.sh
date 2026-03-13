#!/bin/bash

# WiFi Watchdog startup script
# Allows environment variable overrides with sensible defaults

disable_watchdog() {
  echo "WiFi Watchdog is disabled, exiting..."
  exit 0
}

has_ethernet() {
  ip link show | grep -qP '^[0-9]+: eth[^:]+:.*state UP'
}

case "${DISABLE_WIFI_WATCHDOG,,}" in
  "1"|"true")
    disable_watchdog
    ;;
  "auto")
    if has_ethernet; then
      echo "Ethernet connection detected, disabling WiFi Watchdog..."
      disable_watchdog
    fi
    ;;
esac

export WIFI_CHECK_INTERVAL=${WIFI_CHECK_INTERVAL:-30}
export WIFI_OFFLINE_THRESHOLD=${WIFI_OFFLINE_THRESHOLD:-600}
export WIFI_RECOVERY_WAIT=${WIFI_RECOVERY_WAIT:-300}
export MAX_RECOVERY_ATTEMPTS=${MAX_RECOVERY_ATTEMPTS:-3}

echo "WiFi Watchdog Configuration:"
echo "  WIFI_CHECK_INTERVAL: $WIFI_CHECK_INTERVAL seconds"
echo "  WIFI_OFFLINE_THRESHOLD: $WIFI_OFFLINE_THRESHOLD seconds"
echo "  WIFI_RECOVERY_WAIT: $WIFI_RECOVERY_WAIT seconds"
echo "  MAX_RECOVERY_ATTEMPTS: $MAX_RECOVERY_ATTEMPTS"
echo ""

python3 /app/wifi-watchdog.py

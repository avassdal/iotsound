#!/usr/bin/env sh

if [[ -n "$SOUND_DISABLE_AIRPLAY" ]]; then
  echo "Airplay is disabled, exiting..."
  exit 0
fi

# --- ENV VARS ---
# SOUND_DEVICE_NAME: Set the device broadcast name for AirPlay
SOUND_DEVICE_NAME=${SOUND_DEVICE_NAME:-"balenaSound AirPlay $(echo "$BALENA_DEVICE_UUID" | cut -c -4)"}
# SOUND_AIRPLAY_LOG_VERBOSITY: 0 (default) to 3 (most verbose)
SOUND_AIRPLAY_LOG_VERBOSITY=${SOUND_AIRPLAY_LOG_VERBOSITY:-0}
# SOUND_AIRPLAY_LOG_STATS: "yes" to emit periodic statistics
SOUND_AIRPLAY_LOG_STATS=${SOUND_AIRPLAY_LOG_STATS:-no}

CONFIG_PATH="/usr/src/shairport-sync.conf"

cat > "$CONFIG_PATH" <<EOF
diagnostics =
{
  log_output_to = "stderr";
  log_verbosity = ${SOUND_AIRPLAY_LOG_VERBOSITY};
  statistics = "${SOUND_AIRPLAY_LOG_STATS}";
};
EOF

echo "Starting AirPlay plugin..."
echo "Device name: $SOUND_DEVICE_NAME"

# Start AirPlay
echo "Starting Shairport Sync"
exec shairport-sync \
  --configfile "$CONFIG_PATH" \
  --name "$SOUND_DEVICE_NAME" \
  --output alsa \
  -- -d pulse \
  | echo "Shairport-sync started. Device is discoverable as $SOUND_DEVICE_NAME"

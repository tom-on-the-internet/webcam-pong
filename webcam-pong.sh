#!/usr/bin/env bash

set -euf -o pipefail

WEBCAM="C922 Pro Stream"
DEVICE=$(v4l2-ctl --list-devices |grep -A1 "$WEBCAM" | grep -v "$WEBCAM" | xargs)

MIN_PAN=-36000
MAX_PAN=36000
PAN_STEP=3600

MIN_TILT=-36000
MAX_TILT=36000
TILT_STEP=3600

# MIN_ZOOM=100
# MAX_ZOOM=500
# ZOOM_STEP=5

PAN_VALUE=0
PAN_DIRECTION="right"

TILT_VALUE=-20000
TILT_DIRECTION="up"

# ZOOM_VALUE=300
# ZOOM_DIRECTION="in"

while true
do
  [ "$PAN_VALUE" -gt "$MAX_PAN" ] && PAN_DIRECTION="left";
  [ "$PAN_VALUE" -lt "$MIN_PAN" ] && PAN_DIRECTION="right";

  [ "$TILT_VALUE" -gt "$MAX_TILT" ] && TILT_DIRECTION="down";
  [ "$TILT_VALUE" -lt "$MIN_TILT" ] && TILT_DIRECTION="up";

  # [ "$ZOOM_VALUE" -gt "$MAX_ZOOM" ] && ZOOM_DIRECTION="out";
  # [ "$ZOOM_VALUE" -lt "$MIN_ZOOM" ] && ZOOM_DIRECTION="in";

  [ "$PAN_DIRECTION" = "right" ] && PAN_VALUE=$((PAN_VALUE + PAN_STEP))
  [ "$PAN_DIRECTION" = "left" ] && PAN_VALUE=$((PAN_VALUE - PAN_STEP))

  [ "$TILT_DIRECTION" = "up" ] && TILT_VALUE=$((TILT_VALUE + TILT_STEP))
  [ "$TILT_DIRECTION" = "down" ] && TILT_VALUE=$((TILT_VALUE - TILT_STEP))

  # [ "$ZOOM_DIRECTION" = "in" ] && ZOOM_VALUE=$((ZOOM_VALUE + ZOOM_STEP))
  # [ "$ZOOM_DIRECTION" = "out" ] && ZOOM_VALUE=$((ZOOM_VALUE - ZOOM_STEP))

  v4l2-ctl -d "$DEVICE" --set-ctrl=pan_absolute=$PAN_VALUE
  v4l2-ctl -d "$DEVICE" --set-ctrl=tilt_absolute=$TILT_VALUE
  # v4l2-ctl -d "$DEVICE" --set-ctrl=zoom_absolute=$ZOOM_VALUE
  sleep 0.1
done
